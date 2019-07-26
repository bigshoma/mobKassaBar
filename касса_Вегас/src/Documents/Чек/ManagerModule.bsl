
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Представление = ПолучитьПредставлениеЧека(Данные.Ссылка);
	
КонецПроцедуры

Функция ПолучитьПредставлениеЧека(СсылкаНаЧек) Экспорт
	
	РеквизитыЧека = ОбщегоНазначенияВызовСервера.ЗначенияРеквизитовОбъекта(СсылкаНаЧек,
		"Номер, Дата, СтатусЧека, СтатусОплаты, ЭтоЧекКоррекции");
	
	ТекстЗаголовка = НСтр("ru = '%Коррекция%%ПредставлениеНомера% от %ПредставлениеДата% (%СтатусЧека%)'");
	
	ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%ПредставлениеНомера%", 
		ОбщегоНазначенияКлиентСервер.ПредставлениеНомера(РеквизитыЧека.Номер));
		
	ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%ПредставлениеДата%",
		Формат(РеквизитыЧека.Дата,"ДФ=dd.MM; ДЛФ=D"));
	
	Если РеквизитыЧека.СтатусЧека = Перечисления.СтатусыЧеков.Отложен 
		И ЗначениеЗаполнено(РеквизитыЧека.СтатусОплаты) Тогда
		
		СтатусЧека = РеквизитыЧека.СтатусОплаты;
	Иначе
		СтатусЧека = РеквизитыЧека.СтатусЧека;
	КонецЕсли;
	
	Если РеквизитыЧека.ЭтоЧекКоррекции  = Истина Тогда
		
		ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Коррекция%", НСтр("ru = 'Коррекция'") + " ");
	Иначе
		ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Коррекция%", "");
	КонецЕсли;
	
	ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%СтатусЧека%", СтатусЧека);
	
	Возврат ТекстЗаголовка;
	
КонецФункции

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует таблицы значений, содержащие данные документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства) Экспорт
	
	РеквизитыЧека = ОбщегоНазначенияВызовСервера.ЗначенияРеквизитовОбъекта(ДокументСсылка, "ЗаказКлиента");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЧекОплаты.Ссылка.Дата КАК Период,
	|	ЧекОплаты.Ссылка.КассоваяСмена КАК КассоваяСмена,
	|	ВЫБОР
	|		КОГДА ЧекОплаты.Ссылка.ВидОперации = 0
	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	КОНЕЦ КАК ВидДвижения,
	|	ЧекОплаты.ТипОплаты КАК ТипОплаты,
	|	ВЫБОР
	|		КОГДА ЧекОплаты.Ссылка.ВидОперации = 0
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыДвиженияДС.Продажа)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыДвиженияДС.Возврат)
	|	КОНЕЦ КАК ВидДвиженияДС,
	|	ЧекОплаты.Сумма КАК Сумма
	|ИЗ
	|	Документ.Чек.Оплаты КАК ЧекОплаты
	|ГДЕ
	|	ЧекОплаты.Ссылка = &Ссылка
	|	И ЧекОплаты.Ссылка.СтатусЧека В (ЗНАЧЕНИЕ(Перечисление.СтатусыЧеков.Пробит), ЗНАЧЕНИЕ(Перечисление.СтатусыЧеков.Архивный))
	|	И ЧекОплаты.ТипОплаты В (ЗНАЧЕНИЕ(Перечисление.ТипыОплаты.Наличные), ЗНАЧЕНИЕ(Перечисление.ТипыОплаты.ПлатежнаяКарта))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Чек.Дата КАК Период,
	|	ВЫБОР
	|		КОГДА Чек.ВидОперации = 0
	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	КОНЕЦ КАК ВидДвижения,
	|	Чек.ЗаказКлиента КАК ЗаказКлиента,
	|	Чек.ПризнакСпособаРасчета КАК ПризнакСпособаРасчета,
	|	НЕОПРЕДЕЛЕНО КАК ТипОплаты,
	|	Чек.СуммаДокумента КАК Сумма
	|ПОМЕСТИТЬ Расчеты
	|ИЗ
	|	Документ.Чек КАК Чек
	|ГДЕ
	|	&ЕстьЗаказ = ИСТИНА
	|	И Чек.Ссылка = &Ссылка
	|	И Чек.СтатусЧека В (ЗНАЧЕНИЕ(Перечисление.СтатусыЧеков.Пробит), ЗНАЧЕНИЕ(Перечисление.СтатусыЧеков.Архивный))
	|	И Чек.ПризнакСпособаРасчета В (ЗНАЧЕНИЕ(Перечисление.ПризнакиСпособаРасчета.ПередачаБезОплаты), ЗНАЧЕНИЕ(Перечисление.ПризнакиСпособаРасчета.ПередачаСПолнойОплатой), ЗНАЧЕНИЕ(Перечисление.ПризнакиСпособаРасчета.ПередачаСЧастичнойОплатой))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЧекОплаты.Ссылка.Дата,
	|	ВЫБОР
	|		КОГДА ЧекОплаты.Ссылка.ВидОперации = 0
	|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	КОНЕЦ,
	|	ЧекОплаты.Ссылка.ЗаказКлиента,
	|	ЧекОплаты.Ссылка.ПризнакСпособаРасчета,
	|	ЧекОплаты.ТипОплаты,
	|	ЧекОплаты.Сумма
	|ИЗ
	|	Документ.Чек.Оплаты КАК ЧекОплаты
	|ГДЕ
	|	&ЕстьЗаказ = ИСТИНА
	|	И ЧекОплаты.Ссылка = &Ссылка
	|	И ЧекОплаты.ТипОплаты В (ЗНАЧЕНИЕ(Перечисление.ТипыОплаты.Наличные), ЗНАЧЕНИЕ(Перечисление.ТипыОплаты.ПлатежнаяКарта))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Расчеты.Период,
	|	Расчеты.ВидДвижения,
	|	Расчеты.ЗаказКлиента,
	|	Расчеты.ПризнакСпособаРасчета,
	|	Расчеты.ТипОплаты,
	|	Расчеты.Сумма КАК Сумма
	|ИЗ
	|	Расчеты КАК Расчеты";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("ЕстьЗаказ", ЗначениеЗаполнено(РеквизитыЧека.ЗаказКлиента));
	
	Результат = Запрос.ВыполнитьПакет();
	
	ТаблицыДляДвижений = ДополнительныеСвойства.ТаблицыДляДвижений;
	ТаблицыДляДвижений.Вставить("ТаблицаДенежныеСредства",  Результат[0].Выгрузить());
	ТаблицыДляДвижений.Вставить("ТаблицаРасчетыСКлиентами", Результат[2].Выгрузить());
	
КонецПроцедуры

// Возвращает список чеков, которые содержат переданную номенклатуру
// 
// Возвращаемое значение:
//   Массив   - пустой массив, если чеков с номенклатурой нет.
//
Функция СписокЧековСодержащихНоменклатуру(Номенклатура) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЧекТовары.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.Чек.Товары КАК ЧекТовары
		|ГДЕ
		|	ЧекТовары.Номенклатура = &Номенклатура";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	МассивЧеков = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат МассивЧеков;
	
КонецФункции

Функция ДанныеОплатыПоПлатежнойКарте(ДокументСсылка) Экспорт
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ТипОплаты", Перечисления.ТипыОплаты.ПлатежнаяКарта);
	
	НайденнаяОплата = ДокументСсылка.Оплаты.НайтиСтроки(ПараметрыОтбора);
	
	Если НЕ НайденнаяОплата.Количество() = 0 Тогда
		
		Оплата = НайденнаяОплата[0];
		КлючСвязи = Оплата.КлючСвязи;
		
		Операция = ДокументСсылка.ОперацииПлатежнойСистемы.Найти(КлючСвязи, "КлючСвязи");
		
		ДанныеОплаты = Новый Структура;
		ДанныеОплаты.Вставить("ВидОплаты",           Оплата.ВидОплаты);
		ДанныеОплаты.Вставить("Сумма",               Оплата.Сумма);
		ДанныеОплаты.Вставить("ТипОплаты",           Оплата.ТипОплаты);
		ДанныеОплаты.Вставить("КодАвторизации",      Неопределено);
		ДанныеОплаты.Вставить("НомерКарты",          Неопределено);
		ДанныеОплаты.Вставить("НомерСсылкиОперации", Неопределено);
		ДанныеОплаты.Вставить("ДатаОперации",        Неопределено);
		ДанныеОплаты.Вставить("СлипЧек",             Неопределено);
		
		Если НЕ Операция = Неопределено Тогда
			ДанныеОплаты.КодАвторизации      = Операция.КодАвторизации;
			ДанныеОплаты.НомерКарты          = Операция.НомерКарты;
			ДанныеОплаты.НомерСсылкиОперации = Операция.НомерСсылкиОперации;
			ДанныеОплаты.ДатаОперации        = Операция.ДатаОперации;
			ДанныеОплаты.СлипЧек             = Операция.СлипЧек.Получить();
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ДанныеОплаты;
	
КонецФункции

Функция ДанныеОплатыПоПлатежнойКартеПоЗаказу(ДокументСсылка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Операции.Ссылка,
	|	Операции.НомерСтроки,
	|	Операции.ВидОперации,
	|	Операции.КлючСвязи,
	|	Операции.КодАвторизации,
	|	Операции.НомерКарты,
	|	Операции.НомерСсылкиОперации,
	|	Операции.СлипЧек,
	|	Операции.ДатаОперации
	|ПОМЕСТИТЬ Операции
	|ИЗ
	|	Документ.Чек.ОперацииПлатежнойСистемы КАК Операции
	|ГДЕ
	|	Операции.Ссылка.ЗаказКлиента = &ЗаказКлиента
	|	И Операции.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийПлатежнойСистемы.Оплата)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Операции.Ссылка,
	|	Операции.ВидОперации,
	|	Операции.КодАвторизации,
	|	Операции.НомерКарты,
	|	Операции.НомерСсылкиОперации,
	|	Операции.ДатаОперации,
	|	Операции.СлипЧек,
	|	ЧекОплаты.ВидОплаты,
	|	ЧекОплаты.Сумма,
	|	ЧекОплаты.ТипОплаты
	|ИЗ
	|	Операции КАК Операции
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Чек.Оплаты КАК ЧекОплаты
	|		ПО Операции.Ссылка = ЧекОплаты.Ссылка
	|			И Операции.КлючСвязи = ЧекОплаты.КлючСвязи";
	
	Запрос.УстановитьПараметр("ЗаказКлиента", ДокументСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	ДанныеОплаты = Неопределено;
	
	Если НЕ Выборка.Количество() = 0 Тогда
		
		Выборка.Следующий();
		
		ДанныеОплаты = Новый Структура;
		ДанныеОплаты.Вставить("ВидОплаты",           Выборка.ВидОплаты);
		ДанныеОплаты.Вставить("Сумма",               Выборка.Сумма);
		ДанныеОплаты.Вставить("ТипОплаты",           Выборка.ТипОплаты);
		ДанныеОплаты.Вставить("КодАвторизации",      Выборка.КодАвторизации);
		ДанныеОплаты.Вставить("НомерКарты",          Выборка.НомерКарты);
		ДанныеОплаты.Вставить("НомерСсылкиОперации", Выборка.НомерСсылкиОперации);
		ДанныеОплаты.Вставить("ДатаОперации",        Выборка.ДатаОперации);
		ДанныеОплаты.Вставить("СлипЧек",             Выборка.СлипЧек.Получить());
		
	КонецЕсли;
	
	Возврат ДанныеОплаты;
	
КонецФункции

Функция ПолучитьОперацииПлатежнойСистемы(ДокументСсылка) Экспорт
	
	МассивДанных = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЧекОперацииПлатежнойСистемы.ВидОперации,
		|	ЧекОперацииПлатежнойСистемы.КлючСвязи,
		|	ЧекОперацииПлатежнойСистемы.КодАвторизации,
		|	ЧекОперацииПлатежнойСистемы.НомерКарты,
		|	ЧекОперацииПлатежнойСистемы.НомерСсылкиОперации,
		|	ЧекОперацииПлатежнойСистемы.СлипЧек,
		|	ЧекОперацииПлатежнойСистемы.ДатаОперации КАК ДатаОперации
		|ИЗ
		|	Документ.Чек.ОперацииПлатежнойСистемы КАК ЧекОперацииПлатежнойСистемы
		|ГДЕ
		|	ЧекОперацииПлатежнойСистемы.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаОперации";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ДанныеОперации = Новый Структура;
		ДанныеОперации.Вставить("ВидОперации",         Выборка.ВидОперации);
		ДанныеОперации.Вставить("КодАвторизации",      Выборка.КодАвторизации);
		ДанныеОперации.Вставить("НомерКарты",          Выборка.НомерКарты);
		ДанныеОперации.Вставить("НомерСсылкиОперации", Выборка.НомерСсылкиОперации);
		ДанныеОперации.Вставить("СлипЧек",             Выборка.СлипЧек.Получить());
		ДанныеОперации.Вставить("ДатаОперации",        Выборка.ДатаОперации);
		
		МассивДанных.Добавить(ДанныеОперации);
	КонецЦикла;
		
	Возврат МассивДанных;
	
КонецФункции

Функция ПолучитьЧекиВозврата(ЧекПродажи) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ЧекПродажи) Тогда
		
		Возврат Новый Массив;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Чек.Ссылка
		|ИЗ
		|	Документ.Чек КАК Чек
		|ГДЕ
		|	Чек.ЧекПродажи = &ЧекПродажи";
	
	Запрос.УстановитьПараметр("ЧекПродажи", ЧекПродажи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ЧекиВозврата = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат ЧекиВозврата;
	
КонецФункции

Функция ПолучитьЧекПередачиТоваровПоЗаказу(Заказ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Чек.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.Чек КАК Чек
	|ГДЕ
	|	Чек.ЗаказКлиента = &ЗаказКлиента
	|	И Чек.ПризнакСпособаРасчета В (ЗНАЧЕНИЕ(Перечисление.ПризнакиСпособаРасчета.ПередачаСПолнойОплатой), ЗНАЧЕНИЕ(Перечисление.ПризнакиСпособаРасчета.ПередачаБезОплаты), ЗНАЧЕНИЕ(Перечисление.ПризнакиСпособаРасчета.ПередачаСЧастичнойОплатой))
	|	И Чек.СтатусЧека В (ЗНАЧЕНИЕ(Перечисление.СтатусыЧеков.Пробит), ЗНАЧЕНИЕ(Перечисление.СтатусыЧеков.Архивный))
	|	И Чек.Проведен
	|	И Чек.ВидОперации = 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Чек.Дата УБЫВ";
	
	Запрос.УстановитьПараметр("ЗаказКлиента", Заказ);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Возврат Выборка.Ссылка;
		
	Иначе
		
		Возврат Документы.Чек.ПустаяСсылка();
		
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСуммуПереданныхТоваров(ЧекПродажи) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Чек.СуммаДокумента КАК СуммаДокумента
	|ПОМЕСТИТЬ ДанныеЧеков
	|ИЗ
	|	Документ.Чек КАК Чек
	|ГДЕ
	|	Чек.ВидОперации = &ВидОперацииПродажа
	|	И Чек.ПризнакСпособаРасчета В (ЗНАЧЕНИЕ(Перечисление.ПризнакиСпособаРасчета.ПередачаБезОплаты), ЗНАЧЕНИЕ(Перечисление.ПризнакиСпособаРасчета.ПередачаСПолнойОплатой), ЗНАЧЕНИЕ(Перечисление.ПризнакиСпособаРасчета.ПередачаСЧастичнойОплатой))
	|	И Чек.СтатусЧека В (ЗНАЧЕНИЕ(Перечисление.СтатусыЧеков.Пробит), ЗНАЧЕНИЕ(Перечисление.СтатусыЧеков.Архивный))
	|	И Чек.Ссылка = &ЧекПродажи
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	-Чек.СуммаДокумента
	|ИЗ
	|	Документ.Чек КАК Чек
	|ГДЕ
	|	Чек.ВидОперации = &ВидОперацииВозврат
	|	И Чек.ПризнакСпособаРасчета В (ЗНАЧЕНИЕ(Перечисление.ПризнакиСпособаРасчета.ПередачаБезОплаты), ЗНАЧЕНИЕ(Перечисление.ПризнакиСпособаРасчета.ПередачаСПолнойОплатой), ЗНАЧЕНИЕ(Перечисление.ПризнакиСпособаРасчета.ПередачаСЧастичнойОплатой))
	|	И Чек.СтатусЧека В (ЗНАЧЕНИЕ(Перечисление.СтатусыЧеков.Пробит), ЗНАЧЕНИЕ(Перечисление.СтатусыЧеков.Архивный))
	|	И Чек.ЧекПродажи = &ЧекПродажи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ДанныеЧеков.СуммаДокумента) КАК Сумма
	|ИЗ
	|	ДанныеЧеков КАК ДанныеЧеков";
	
	Запрос.УстановитьПараметр("ВидОперацииВозврат", ПродажиКлиентСерверПовтИсп.ВидОперацииЧека_Возврат());
	Запрос.УстановитьПараметр("ВидОперацииПродажа", ПродажиКлиентСерверПовтИсп.ВидОперацииЧека_Продажа());
	Запрос.УстановитьПараметр("ЧекПродажи", ЧекПродажи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Сумма;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции

Функция ПолучитьДанныеДляФискализацииЧека(СсылкаНаЧек, ЭтоПречек, ДанныеРасчетов = Неопределено, ЗаполнятьОплату = Ложь) Экспорт
	
	ПозицииЧека = Новый Массив();
	
	ПараметрыФормыОплаты = Новый Структура;
	ОбщиеПараметры = Новый Структура;
	
	// Товары
	ПозицииЧека = Новый Массив;
	
#Область Запрос
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Чек.Ссылка КАК Ссылка,
	|	Чек.Дата КАК Дата,
	|	Чек.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	Чек.ШтрихкодЧека КАК ШтрихкодЧека,
	|	Чек.ВидОперации КАК ВидОперации,
	|	Чек.СуммаДокумента КАК СуммаДокумента,
	|	Чек.ЧекПродажи КАК ЧекПродажи,
	|	Чек.ЗаказКлиента КАК ЗаказКлиента,
	|	Чек.Номер КАК Номер,
	|	Чек.ПризнакСпособаРасчета КАК ПризнакСпособаРасчета,
	|	Чек.СистемаНалогообложенияККТ КАК СистемаНалогообложенияККТ,
	|	Чек.ЭтоЧекКоррекции КАК ЭтоЧекКоррекции,
	|	Чек.НеприменениеККТ КАК НеприменениеККТ,
	|	Чек.ТипКоррекции КАК ТипКоррекции,
	|	Чек.ДатаКоррекции КАК ДатаКоррекции,
	|	Чек.ОписаниеКоррекции КАК ОписаниеКоррекции,
	|	Чек.НомерПредписания КАК НомерПредписания,
	|	Чек.ЧекОснование КАК ЧекОснование,
	|	Чек.ЧекОснование.ФискальныйПризнак КАК ОснованиеФискальныйПризнак,
	|	Чек.АдресРасчета КАК АдресРасчета,
	|	Чек.МестоРасчета КАК МестоРасчета
	|ИЗ
	|	Документ.Чек КАК Чек
	|ГДЕ
	|	Чек.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтрокиТовара,
	|	Товары.КлючСвязи КАК КлючСвязи,
	|	Товары.Количество КАК Количество,
	|	Товары.Номенклатура.Наименование КАК Наименование,
	|	Товары.Номенклатура.Артикул КАК Артикул,
	|	Товары.Номенклатура.ПризнакПредметаРасчета КАК ПризнакПредметаРасчета,
	|	Товары.СтавкаНДС КАК СтавкаНДС,
	|	Товары.Сумма КАК Сумма,
	|	Товары.СуммаНДС КАК СуммаНДС,
	|	Товары.Цена КАК Цена,
	|	Товары.Штрихкод КАК Штрихкод,
	|	Товары.ЦенаСУчетомСкидки КАК ЦенаСУчетомСкидки,
	|	Товары.Номенклатура.ДанныеАгента КАК ДанныеАгента,
	|	Товары.Номенклатура.ДанныеПоставщика КАК ДанныеПоставщика,
	|	Товары.СкидкаНаценкаСумма КАК СкидкаНаценкаСумма
	|ИЗ
	|	Документ.Чек.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Товары.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЧекОплаты.Ссылка КАК Ссылка,
	|	ЧекОплаты.НомерСтроки КАК НомерСтроки,
	|	ЧекОплаты.ВидОплаты КАК ВидОплаты,
	|	ЧекОплаты.Сумма КАК Сумма,
	|	ЧекОплаты.ТипОплаты КАК ТипОплаты,
	|	ЧекОплаты.КлючСвязи КАК КлючСвязи
	|ИЗ
	|	Документ.Чек.Оплаты КАК ЧекОплаты
	|ГДЕ
	|	ЧекОплаты.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЧекТовары.НомерСтроки КАК НомерСтроки,
	|	ЧекТовары.Номенклатура КАК Номенклатура,
	|	ЧекТовары.Номенклатура.ДанныеАгента.ПризнакАгента КАК ПризнакАгента,
	|	ЧекТовары.Номенклатура.ДанныеАгента.ОперацияПлатежногоАгента КАК ОперацияПлатежногоАгента,
	|	ЧекТовары.Номенклатура.ДанныеАгента.ТелефонПлатежногоАгента КАК ТелефонПлатежногоАгента,
	|	ЧекТовары.Номенклатура.ДанныеАгента.ТелефонОператораПоПриемуПлатежей КАК ТелефонОператораПоПриемуПлатежей,
	|	ЧекТовары.Номенклатура.ДанныеАгента.ТелефонОператораПеревода КАК ТелефонОператораПеревода,
	|	ЧекТовары.Номенклатура.ДанныеАгента.НаименованиеОператораПеревода КАК НаименованиеОператораПеревода,
	|	ЧекТовары.Номенклатура.ДанныеАгента.АдресОператораПеревода КАК АдресОператораПеревода,
	|	ЧекТовары.Номенклатура.ДанныеАгента.ИННОператораПеревода КАК ИННОператораПеревода,
	|	ЧекТовары.Номенклатура.ДанныеПоставщика.ИННПоставщикаУслуг КАК ИННПоставщикаУслуг,
	|	ЧекТовары.Номенклатура.ДанныеПоставщика.ПоставщикУслуг КАК ПоставщикУслуг,
	|	ЧекТовары.Номенклатура.ДанныеПоставщика.ТелефонПоставщика КАК ТелефонПоставщика
	|ИЗ
	|	Документ.Чек.Товары КАК ЧекТовары
	|ГДЕ
	|	ЧекТовары.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЧекМарки.КлючСвязи КАК КлючСвязи,
	|	ЧекМарки.КодМаркировки КАК КодМаркировки,
	|	ЧекМарки.ТипМаркировки КАК ТипМаркировки,
	|	ЧекМарки.ГлобальныйИдентификаторТорговойЕдиницы КАК ГлобальныйИдентификаторТорговойЕдиницы,
	|	ЧекМарки.СерийныйНомер КАК СерийныйНомер
	|ИЗ
	|	Документ.Чек.Марки КАК ЧекМарки
	|ГДЕ
	|	ЧекМарки.ТипМаркировки В (ЗНАЧЕНИЕ(Перечисление.ТипыМаркировкиККТ.ИзделияИзМеха), ЗНАЧЕНИЕ(Перечисление.ТипыМаркировкиККТ.ТабачнаяПродукция), ЗНАЧЕНИЕ(Перечисление.ТипыМаркировкиККТ.ОбувныеТовары))
	|	И ЧекМарки.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаЧек);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
#КонецОбласти
	
	РеквизитыЧека = РезультатЗапроса[0].Выбрать();
	РеквизитыЧека.Следующий();
	
	Выборка = РезультатЗапроса[1].Выбрать();
	Оплаты = РезультатЗапроса[2].Выгрузить();
	ДанныеПлатежныхАгентов = РезультатЗапроса[3].Выгрузить();
	Марки = РезультатЗапроса[4].Выгрузить();
	
	НомерСтрокиТовара = 1;
	
	СтруктураПоискаМарок = Новый Структура;
	СтруктураПоискаМарок.Вставить("КлючСвязи");
	
	Пока Выборка.Следующий() Цикл
		
		КоличествоМарок = 0;
		
		Если ЗначениеЗаполнено(Выборка.КлючСвязи) Тогда
			СтруктураПоискаМарок.КлючСвязи = Выборка.КлючСвязи;
			
			МаркиСтроки = Марки.НайтиСтроки(СтруктураПоискаМарок);
			КоличествоМарок = МаркиСтроки.Количество();
		КонецЕсли;
	
		Если КоличествоМарок > 0 Тогда
			
			КоличествоТоваров  = Выборка.Количество;
			Сумма              = Выборка.Сумма;
			СкидкаНаценкаСумма = Выборка.СкидкаНаценкаСумма;
			
			// распределение суммы
			Коэффициенты = Новый Массив(КоличествоМарок);
			Индекс = 0;
			Для Каждого _ Из Коэффициенты Цикл
				Коэффициенты[Индекс] = 1;
				Индекс = Индекс + 1;
			КонецЦикла;
			
			РаспределенныеСуммыПоМаркам = ОбщегоНазначенияКлиентСервер.РаспределитьСуммуПропорциональноКоэффициентам(
				Сумма, Коэффициенты);
			
			РаспределенныеСкидкиНаценкиПоМаркам = ОбщегоНазначенияКлиентСервер.РаспределитьСуммуПропорциональноКоэффициентам(
				СкидкаНаценкаСумма, Коэффициенты);
			
			// заполнение строк фискализации
			Индекс = 0;
			Для Каждого Марка Из МаркиСтроки Цикл
				
				СтрокаПозицииЧека = ЗаполнитьПозициюЧека(
					Выборка,
					РеквизитыЧека.ЦенаВключаетНДС,
					1,
					РаспределенныеСуммыПоМаркам[Индекс],
					?(СкидкаНаценкаСумма = 0, 0, РаспределенныеСкидкиНаценкиПоМаркам[Индекс])
				);
				
				ЗаполнитьЗначенияСвойств(СтрокаПозицииЧека.ДанныеКодаТоварнойНоменклатуры,
					Марка,
					"ТипМаркировки, СерийныйНомер, ГлобальныйИдентификаторТорговойЕдиницы"
				);
				СтрокаПозицииЧека.ДанныеКодаТоварнойНоменклатуры.КонтрольныйИдентификационныйЗнак = Марка.КодМаркировки;
				
				СтрокаПозицииЧека.НомерСтрокиТовара = НомерСтрокиТовара;
				
				НомерСтрокиТовара = НомерСтрокиТовара + 1;
				
				ПозицииЧека.Добавить(СтрокаПозицииЧека);
				
				Индекс = Индекс + 1;
			КонецЦикла;
			
		Иначе
			
			СтрокаПозицииЧека = ЗаполнитьПозициюЧека(Выборка, РеквизитыЧека.ЦенаВключаетНДС,,,, Выборка.СуммаНДС);
			ПозицииЧека.Добавить(СтрокаПозицииЧека);
			НомерСтрокиТовара = НомерСтрокиТовара +1;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ЗначениеНастроекВызовСервераПовтИсп.ОборудованиеПечати()) Тогда
		
		Если (ЭтоПречек И ЗначениеНастроекВызовСервераПовтИсп.ПечататьШтрихкодНаПречеке())
			ИЛИ (НЕ ЭтоПречек И ЗначениеНастроекВызовСервераПовтИсп.ПечататьШтрихкодНаЧеке())Тогда
			
			СтрокаШтрихкода = МенеджерОборудованияКлиентСервер.ПараметрыШтрихкодВСтрокеЧека("EAN13", РеквизитыЧека.ШтрихкодЧека);
			ПозицииЧека.Добавить(СтрокаШтрихкода);
			
		КонецЕсли;
		
	КонецЕсли;
	
	// ПОДГОТОВКА ТАБЛИЦЫ ОПЛАТ
	
	ТаблицаОплат = Новый Массив();
	
	// ПОДГОТОВКА ОБЩИХ ПАРАМЕТРОВ
	
	// Структура чека
	ОбщиеПараметры = Новый Структура();
	
	Если РеквизитыЧека.ВидОперации = ПродажиКлиентСерверПовтИсп.ВидОперацииЧека_Продажа() Тогда
		
		ТипЧека = ПродажиКлиентСерверПовтИсп.ТипЧека_Продажа();
		
	ИначеЕсли РеквизитыЧека.ВидОперации = ПродажиКлиентСерверПовтИсп.ВидОперацииЧека_Возврат() Тогда
		
		ТипЧека = ПродажиКлиентСерверПовтИсп.ТипЧека_ВозвратПродажи();
		
	КонецЕсли;
	
	ПараметрыФормыОплаты.Вставить("СуммаДокумента",  РеквизитыЧека.СуммаДокумента);
	
	Если ДанныеРасчетов = Неопределено Тогда
		
		ПараметрыФормыОплаты.Вставить("ПредоплатаАванс", 0);
		ПараметрыФормыОплаты.Вставить("ДолгКлиента", 0);
		ПараметрыФормыОплаты.Вставить("ДанныеОплатыПоПлатежнойКартеЧекаПродажи", 0);
		ПараметрыФормыОплаты.Вставить("ДоступнаяСуммаВозвратаНаличные", 0);
		ПараметрыФормыОплаты.Вставить("ДоступнаяСуммаВозвратаПлатежнаяКарта", 0);
		ПараметрыФормыОплаты.Вставить("ИспользуютсяРасчетыСКлиентами", 0);
		
	Иначе
		
		ПараметрыФормыОплаты.Вставить("ПредоплатаАванс", ДанныеРасчетов.ОплаченоПредоплата);
		ПараметрыФормыОплаты.Вставить("ДолгКлиента",     ДанныеРасчетов.ДолгКлиента);
		
		ПараметрыФормыОплаты.Вставить("ДанныеОплатыПоПлатежнойКартеЧекаПродажи",
			ОпределитьДанныеОплатыПоПлатежнойКартеЧекаПродажи(ДанныеРасчетов.ИспользуютсяРасчетыСКлиентами, СсылкаНаЧек)
		);
		
		ПараметрыФормыОплаты.Вставить("ДоступнаяСуммаВозвратаНаличные", ДанныеРасчетов.ДоступнаяСуммаВозвратаНаличные);
		ПараметрыФормыОплаты.Вставить("ДоступнаяСуммаВозвратаПлатежнаяКарта", ДанныеРасчетов.ДоступнаяСуммаВозвратаПлатежнаяКарта);
		ПараметрыФормыОплаты.Вставить("ИспользуютсяРасчетыСКлиентами", ДанныеРасчетов.ИспользуютсяРасчетыСКлиентами);
		
	КонецЕсли;
		
	ПараметрыФормыОплаты.Вставить("ВидОперации", РеквизитыЧека.ВидОперации);
	
	Если Оплаты.Количество() = 0 Тогда
		ПараметрыФормыОплаты.Вставить("ДанныеОплатыПоПлатежнойКарте");
	Иначе
		ПараметрыФормыОплаты.Вставить("ДанныеОплатыПоПлатежнойКарте", ПолучитьДанныеОплатыПоПлатежнойКарте(СсылкаНаЧек));
	КонецЕсли;
	
	ПараметрыФормыОплаты.Вставить("ВидОплаты",  Неопределено);
	ПараметрыФормыОплаты.Вставить("ЧекПродажи", РеквизитыЧека.ЧекПродажи);
	ПараметрыФормыОплаты.Вставить("Заказ",      РеквизитыЧека.ЗаказКлиента);
	
	
	ОбщиеПараметры.Вставить("ТипЧека"      , ТипЧека);
	ОбщиеПараметры.Вставить("ТаблицаОплат" , ТаблицаОплат);
	ОбщиеПараметры.Вставить("НомерЧека"    , РеквизитыЧека.Номер);
	ОбщиеПараметры.Вставить("НомерСмены"   , ПродажиВызовСервера.ПолучитьНомерСмены());
	ОбщиеПараметры.Вставить("ПозицииЧека"  , ПозицииЧека);
	ОбщиеПараметры.Вставить("ПризнакСпособаРасчета", РеквизитыЧека.ПризнакСпособаРасчета);
	ОбщиеПараметры.Вставить("Основание",	 РеквизитыЧека.ЗаказКлиента);
	
	ОбщиеПараметры.Вставить("ЭтоЧекКоррекции",	 РеквизитыЧека.ЭтоЧекКоррекции);
	ОбщиеПараметры.Вставить("НеприменениеККТ",	 РеквизитыЧека.НеприменениеККТ);
	ОбщиеПараметры.Вставить("ДатаКоррекции",	 РеквизитыЧека.ДатаКоррекции);
	ОбщиеПараметры.Вставить("ОписаниеКоррекции", РеквизитыЧека.ОписаниеКоррекции);
	ОбщиеПараметры.Вставить("ЧекОснование",		 РеквизитыЧека.ЧекОснование);
	ОбщиеПараметры.Вставить("НомерПредписания",	 РеквизитыЧека.НомерПредписания);
	ОбщиеПараметры.Вставить("ОснованиеФискальныйПризнак", РеквизитыЧека.ОснованиеФискальныйПризнак);
	ОбщиеПараметры.Вставить("ТипКоррекции");
	ОбщиеПараметры.Вставить("АдресРасчета", РеквизитыЧека.АдресРасчета);
	ОбщиеПараметры.Вставить("МестоРасчета", РеквизитыЧека.МестоРасчета);
	
	Если РеквизитыЧека.ТипКоррекции = Перечисления.ТипыКоррекции.Самостоятельно Тогда
		
		ОбщиеПараметры.Вставить("ТипКоррекции", ПродажиКлиентСерверПовтИсп.ТипКоррекции_Самостоятельно());
		
	ИначеЕсли РеквизитыЧека.ТипКоррекции = Перечисления.ТипыКоррекции.ПоПредписанию Тогда
		
		ОбщиеПараметры.Вставить("ТипКоррекции", ПродажиКлиентСерверПовтИсп.ТипКоррекции_ПоПредписанию());
	КонецЕсли;
	
	ОбщиеПараметры.Вставить("СистемаНалогообложения", ЗначениеНастроекВызовСервераПовтИсп.СистемаНалогообложенияККТ());
	
	ОбщиеПараметры.Вставить("ПараметрыЧекаЕГАИС" , Неопределено);
	
	Если ЗначениеНастроекВызовСервераПовтИсп.ИспользуетсяЕГАИСПриПродаже() Тогда
		ОбщиеПараметры.ПараметрыЧекаЕГАИС = ПодготовитьДанныеДляПодписиЧека(СсылкаНаЧек);
	КонецЕсли;
	
	Если ЗаполнятьОплату Тогда
		
		Для Каждого Оплата Из Оплаты Цикл
			
			СтрокаОплаты = МенеджерОборудованияКлиентСервер.ПараметрыСтрокиОплаты();
			
			СтрокаОплаты.ТипОплаты = ПодключаемоеОборудование.ПолучитьТипОплатыККТ(Оплата.ТипОплаты);
			СтрокаОплаты.Сумма = Оплата.Сумма;
			
			ОбщиеПараметры.ТаблицаОплат.Добавить(СтрокаОплаты);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ПараметрыФормыОплаты.Вставить("ОбщиеПараметры", ОбщиеПараметры);
	
	Возврат ПараметрыФормыОплаты;
	
КонецФункции

Функция ЗаполнитьПозициюЧека(Выборка, ЦенаВключаетНДС,
	Количество = Неопределено, Сумма = Неопределено, СкидкаНаценкаСумма = Неопределено, СуммаНДС = Неопределено)
	
	СтрокаПозицииЧека = МенеджерОборудованияКлиентСервер.ПараметрыФискальнойСтрокиЧека();
	
	СтрокаПозицииЧека.Наименование = ПолучитьНаименованиеТовара(Выборка);
	
	Если Количество = Неопределено Тогда
		СтрокаПозицииЧека.Количество = Выборка.Количество;
	Иначе
		СтрокаПозицииЧека.Количество = Количество;
	КонецЕсли;
	
	Если Сумма = Неопределено Тогда
		СтрокаПозицииЧека.Сумма = Выборка.Сумма;
	Иначе
		СтрокаПозицииЧека.Сумма = Сумма;
	КонецЕсли;
	
	СтрокаПозицииЧека.Цена = Выборка.Цена;
	
	Если СкидкаНаценкаСумма = Неопределено Тогда
		СкидкаНаценкаСумма = Выборка.СкидкаНаценкаСумма;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СкидкаНаценкаСумма) Тогда
		СтрокаПозицииЧека.СуммаСкидок = - СкидкаНаценкаСумма;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Выборка.ПризнакПредметаРасчета) Тогда
		СтрокаПозицииЧека.ПризнакПредметаРасчета = Выборка.ПризнакПредметаРасчета;
	Иначе
		СтрокаПозицииЧека.ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.Товар;
	КонецЕсли;
	
	
	Ставка = Неопределено;
	Если СуммаНДС = Неопределено Тогда
		
		Если ЦенаВключаетНДС Тогда
			
			Ставка = ЦенообразованиеКлиентСерверПовтИсп.ПолучитьСтавкуНДСЦелымЧислом(Выборка.СтавкаНДС);
			ПроцентНДС = ЦенообразованиеКлиентСерверПовтИсп.ПолучитьСтавкуНДСЧислом(Выборка.СтавкаНДС);
			СуммаНДС = ЦенообразованиеКлиентСервер.РассчитатьСуммуНДС(СтрокаПозицииЧека.Сумма, ПроцентНДС);
			
			СтрокаПозицииЧека.СуммаНДС = СуммаНДС;
			
		КонецЕсли;
		
	Иначе
		
		Если ЦенаВключаетНДС Тогда
			Ставка = ЦенообразованиеКлиентСерверПовтИсп.ПолучитьСтавкуНДСЦелымЧислом(Выборка.СтавкаНДС);
			СтрокаПозицииЧека.СуммаНДС = Выборка.СуммаНДС;
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокаПозицииЧека.СтавкаНДС = Ставка;
	
	// ПризнакСпособаРасчета - заполняется при пробитии, т.к. может измениться при оплате
	
	Возврат СтрокаПозицииЧека;
	
КонецФункции

Функция ПолучитьНаименованиеТовара(Выборка)
	
	ШаблонНаименования = ЗначениеНастроекПовтИсп.ШаблонВыводаНаименованияТовара();
	
	Если НЕ ЗначениеЗаполнено(ШаблонНаименования) ИЛИ НЕ ЗначениеЗаполнено(Выборка.Артикул) Тогда
		
		Возврат Выборка.Наименование;
		
	ИначеЕсли ШаблонНаименования = Перечисления.ШаблоныВыводаНаименованияТовара.АртикулНаименование Тогда
		
		Возврат Выборка.Артикул + " " + Выборка.Наименование;
		
	ИначеЕсли ШаблонНаименования = Перечисления.ШаблоныВыводаНаименованияТовара.НаименованиеАртикул Тогда
		
		Возврат Выборка.Наименование + " " + Выборка.Артикул;
	Иначе
		
		Возврат Выборка.Наименование;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьПараметрыФискализацииПробитогоЧека(Знач СсылкаНаЧек) Экспорт
	
	ДанныеДляФискализацииЧека = ПолучитьДанныеДляФискализацииЧека(СсылкаНаЧек, Ложь, Неопределено, Истина);
	
	Возврат ДанныеДляФискализацииЧека;
	
КонецФункции

Функция ПолучитьЧекКоррекции(СсылкаНаЧек) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Чек.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.Чек КАК Чек
		|ГДЕ
		|	Чек.ЧекОснование = &ЧекОснование
		|	И Чек.ЭтоЧекКоррекции
		|	И Чек.СтатусЧека В (ЗНАЧЕНИЕ(Перечисление.СтатусыЧеков.Пробит), ЗНАЧЕНИЕ(Перечисление.СтатусыЧеков.Архивный))
		|	И Чек.Проведен
		|	И Чек.ВидОперации = &ВидОперации";
	
	Запрос.УстановитьПараметр("ЧекОснование", СсылкаНаЧек);
	
	Запрос.УстановитьПараметр("ВидОперации",
		ПродажиКлиентСерверПовтИсп.ВидОперацииЧека_Продажа()
	);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДанныеОплатыПоПлатежнойКарте(Ссылка)
	
	Возврат ДанныеОплатыПоПлатежнойКарте(Ссылка);
	
КонецФункции

Функция ПодготовитьДанныеДляПодписиЧека(СсылкаНаЧек)
	
	Возврат ИнтеграцияЕГАИСМК.ПодготовитьВходящиеДанныеДляПодписиЧека(СсылкаНаЧек);
	
КонецФункции

Функция ОпределитьДанныеОплатыПоПлатежнойКартеЧекаПродажи(ИспользуютсяРасчетыСКлиентами, РеквизитыЧека)
	
	Если ИспользуютсяРасчетыСКлиентами Тогда
		
		ДанныеОплатыПоПлатежнойКартеЧекаПродажи = ДанныеОплатыПоПлатежнойКартеПоЗаказу(РеквизитыЧека.ЗаказКлиента);
	Иначе
		
		ДанныеОплатыПоПлатежнойКартеЧекаПродажи = ДанныеОплатыПоПлатежнойКарте(РеквизитыЧека.ЧекПродажи);
	КонецЕсли;
	
	Возврат ДанныеОплатыПоПлатежнойКартеЧекаПродажи;
	
КонецФункции

#КонецОбласти

#КонецЕсли