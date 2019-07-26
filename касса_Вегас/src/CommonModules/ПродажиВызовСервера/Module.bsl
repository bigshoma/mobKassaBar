
#Область ПрограммныйИнтерфейс

Функция ПолучитьСмену(ОткрыватьСмену = Истина) Экспорт
	
	КассоваяСмена = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КассоваяСмена.Ссылка
	|ИЗ
	|	Документ.КассоваяСмена КАК КассоваяСмена
	|ГДЕ
	|	КассоваяСмена.Проведен
	|	И НЕ КассоваяСмена.Закрыта";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		КассоваяСмена = Выборка.Ссылка;
	Иначе
		Если ОткрыватьСмену Тогда
			
			КассоваяСмена = ПродажиВызовСервера.ОткрытьДокументКассоваяСмена();
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат КассоваяСмена;
	
КонецФункции

Функция ПолучитьНомерСмены() Экспорт
	
	ОткрытаяСмена = ПолучитьСмену(Ложь);
	
	Если НЕ ОткрытаяСмена = Неопределено Тогда
		
		Возврат ОткрытаяСмена.Номер;
	КонецЕсли;
	
	ПоследняяСмена = ПолучитьПоследнююЗакрытуюСмену();
	
	Если НЕ ПоследняяСмена = Неопределено Тогда
		
		Возврат ПоследняяСмена.Номер + 1;
	КонецЕсли;
	
	НомерПервойСмены = 1;
	
	Возврат НомерПервойСмены;
	
КонецФункции

Функция ПроверитьВозможностьВводаЧека() Экспорт
	
	ВводЧекаРазрешен = Истина;
	
	Если ЗначениеНастроекПовтИсп.ЭтоДемоверсия() Тогда
		
		МаксимальноеКоличествоЧеков = 500;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Чек.Ссылка
		|ИЗ
		|	Документ.Чек КАК Чек";
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Если Выборка.Количество() >= МаксимальноеКоличествоЧеков Тогда
			ВводЧекаРазрешен = Ложь;
			
			ТекстСообщения = НСтр("ru = 'Ограничение демонстрационной версии.
			|Превышение максимального количества чеков (500).'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат ВводЧекаРазрешен;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЗначениеНастроекВызовСервераПовтИсп.УстановленРежимСинхронизации() Тогда
		ВводЧекаРазрешен = Ложь;
		ТекстСообщения = НСтр("ru = 'Не установлен режим синхронизации приложения.
									|(Настройки - Режим синхронизации)'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат ВводЧекаРазрешен;
	КонецЕсли;
	
	Если ЗначениеНастроекВызовСервераПовтИсп.УстановленРежимСинхронизации()
		И НЕ ЗначениеНастроекВызовСервераПовтИсп.ЗаполненыПараметрыСинхронизации()
		И НЕ ЗначениеНастроекВызовСервераПовтИсп.ЭтоАвтономныйРежим() Тогда
		
		ВводЧекаРазрешен = Ложь;
		ТекстСообщения = НСтр("ru = 'Не установлены параметры синхронизации.
									|(Настройки - Параметры синхронизации)'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат ВводЧекаРазрешен;
	КонецЕсли;
	
	Если НЕ ЗначениеНастроекВызовСервераПовтИсп.ЗаполненыПараметрыУчета() Тогда
		ВводЧекаРазрешен = Ложь;
		ТекстСообщения = НСтр("ru = 'Не заполнены необходимые параметры учета.
			|(Настройки - Параметры учета)'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат ВводЧекаРазрешен;
	КонецЕсли;
	
	Возврат ВводЧекаРазрешен;
	
КонецФункции

Функция ПолучитьОстатокНаличныхВКассе(КассоваяСмена = Неопределено) Экспорт
	
	Остаток = 0;
	
	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	НаличныеОстатки.СуммаОстаток КАК СуммаОстаток
	|ИЗ
	|	РегистрНакопления.ДенежныеСредства.Остатки(, ТипОплаты = ЗНАЧЕНИЕ(Перечисление.ТипыОплаты.Наличные) %Условие%) КАК НаличныеОстатки";
	
	Если КассоваяСмена = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%Условие%", "");
		
	Иначе
		Условие = "И КассоваяСмена = &КассоваяСмена";
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%Условие%", Условие);
		Запрос.УстановитьПараметр("КассоваяСмена", КассоваяСмена);
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
		
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Остаток = Выборка.СуммаОстаток;
		
	КонецЕсли;
	
	Возврат Остаток;
	
КонецФункции

Функция ОткрытьДокументКассоваяСмена(НомерСмены = Неопределено) Экспорт
	
	КассоваяСменаОбъект = Документы.КассоваяСмена.СоздатьДокумент();
	КассоваяСменаОбъект.Дата = ОбщегоНазначенияКлиентСервер.ПолучитьТекущуюДату();
	КассоваяСменаОбъект.НачалоКассовойСмены = ОбщегоНазначенияКлиентСервер.ПолучитьТекущуюДату();
	КассоваяСменаОбъект.Кассир = ПараметрыСеанса.ТекущийПользователь;
	
	Если НЕ НомерСмены = Неопределено тогда
		КассоваяСменаОбъект.НомерСмены = НомерСмены;
	КонецЕсли;
	
	КассоваяСменаОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
	Возврат КассоваяСменаОбъект.Ссылка;
	
КонецФункции

Процедура ЗакрытьДокументКассоваяСмена() Экспорт
	
	КассоваяСмена = ПродажиВызовСервераПовтИсп.ПолучитьСмену(Ложь);
	
	Если КассоваяСмена = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивДокументовКПроведению = Новый Массив;
	
	СписокНеПроведенныхДокументов = Новый СписокЗначений;
	СписокДокументов = Новый СписокЗначений;
	
	// Запрос по чекам
	ЗапросПоЧекам = Новый Запрос;
	
	ЗапросПоЧекам.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Док.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.Чек КАК Док
	|ГДЕ
	|	Док.КассоваяСмена = &КассоваяСмена
	|	И Док.Ссылка.Проведен
	|	И Док.Ссылка.СтатусЧека = ЗНАЧЕНИЕ(Перечисление.СтатусыЧеков.Пробит)
	|
	|";
	
	ЗапросПоЧекам.УстановитьПараметр("КассоваяСмена", КассоваяСмена);
	
	//// Запрос по товарам
	ЗапросПоТоварам = Новый Запрос;
	ЗапросПоТоварам.УстановитьПараметр("КассоваяСмена", КассоваяСмена);
	ЗапросПоТоварам.УстановитьПараметр("ВидОперацииПродажа", 0);
	ЗапросПоТоварам.Текст =
	"ВЫБРАТЬ
	|	Док.Номенклатура КАК Номенклатура,
	|	Док.Ссылка.ВидОперации,
	|	Док.Количество,
	|	Док.Сумма / Док.Количество КАК Цена,
	|	Док.СтавкаНДС КАК СтавкаНДС,
	|	Док.СуммаНДС КАК СуммаНДС,
	|	Док.Сумма КАК Сумма
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	Документ.Чек.Товары КАК Док
	|ГДЕ
	|	Док.Ссылка.КассоваяСмена = &КассоваяСмена
	|	И Док.Ссылка.Проведен
	|	И Док.Ссылка.СтатусЧека = ЗНАЧЕНИЕ(Перечисление.СтатусыЧеков.Пробит)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыОбщие.Номенклатура,
	|	ТоварыОбщие.Количество,
	|	ТоварыОбщие.Цена,
	|	ТоварыОбщие.СтавкаНДС,
	|	ТоварыОбщие.СуммаНДС,
	|	ТоварыОбщие.Сумма
	|ПОМЕСТИТЬ ТаблицаТовары
	|ИЗ
	|	(ВЫБРАТЬ
	|		Товары.Номенклатура КАК Номенклатура,
	|		СУММА(ВЫБОР
	|				КОГДА Товары.ВидОперации = &ВидОперацииПродажа
	|					ТОГДА Товары.Количество
	|				ИНАЧЕ -Товары.Количество
	|			КОНЕЦ) КАК Количество,
	|		Товары.Цена КАК Цена,
	|		Товары.СтавкаНДС КАК СтавкаНДС,
	|		СУММА(ВЫБОР
	|				КОГДА Товары.ВидОперации = &ВидОперацииПродажа
	|					ТОГДА Товары.СуммаНДС
	|				ИНАЧЕ -Товары.СуммаНДС
	|			КОНЕЦ) КАК СуммаНДС,
	|		СУММА(ВЫБОР
	|				КОГДА Товары.ВидОперации = &ВидОперацииПродажа
	|					ТОГДА Товары.Сумма
	|				ИНАЧЕ -Товары.Сумма
	|			КОНЕЦ) КАК Сумма
	|	ИЗ
	|		Товары КАК Товары
	|	
	|	СГРУППИРОВАТЬ ПО
	|		Товары.Номенклатура,
	|		Товары.СтавкаНДС,
	|		Товары.Цена
	|	
	|	ИМЕЮЩИЕ
	|		СУММА(ВЫБОР
	|				КОГДА Товары.ВидОперации = &ВидОперацииПродажа
	|					ТОГДА Товары.Количество
	|				ИНАЧЕ -Товары.Количество
	|			КОНЕЦ) <> 0) КАК ТоварыОбщие
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура,
	|	СУММА(ТаблицаТовары.Количество) КАК Количество,
	|	ТаблицаТовары.Цена,
	|	ТаблицаТовары.СтавкаНДС,
	|	СУММА(ТаблицаТовары.СуммаНДС) КАК СуммаНДС,
	|	СУММА(ТаблицаТовары.Сумма) КАК Сумма
	|ИЗ
	|	ТаблицаТовары КАК ТаблицаТовары
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.СтавкаНДС,
	|	ТаблицаТовары.Цена";
	
	
	// Запрос по возвратам
	ЗапросПоВозвратам = Новый Запрос;
	ЗапросПоВозвратам.УстановитьПараметр("КассоваяСмена", КассоваяСмена);
	ЗапросПоВозвратам.УстановитьПараметр("ВидОперацииВозврат", 1);
	ЗапросПоВозвратам.Текст =
	"ВЫБРАТЬ
	|	ТоварыБезКомплектов.Номенклатура,
	|	ТоварыБезКомплектов.Количество,
	|	ТоварыБезКомплектов.Цена,
	|	ТоварыБезКомплектов.СтавкаНДС,
	|	ТоварыБезКомплектов.СуммаНДС,
	|	ТоварыБезКомплектов.Сумма
	|ИЗ
	|	(ВЫБРАТЬ
	|		Док.Номенклатура КАК Номенклатура,
	|		СУММА(Док.Количество) КАК Количество,
	|		Док.Цена КАК Цена,
	|		Док.СтавкаНДС КАК СтавкаНДС,
	|		СУММА(Док.СуммаНДС) КАК СуммаНДС,
	|		СУММА(Док.Сумма) КАК Сумма
	|	ИЗ
	|		Документ.Чек.Товары КАК Док
	|	ГДЕ
	|		Док.Ссылка.ВидОперации = &ВидОперацииВозврат
	|		И Док.Ссылка.КассоваяСмена = &КассоваяСмена
	|		И Док.Ссылка.Проведен
	|		И Док.Ссылка.СтатусЧека = ЗНАЧЕНИЕ(Перечисление.СтатусыЧеков.Пробит)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		Док.Номенклатура,
	|		Док.СтавкаНДС,
	|		Док.Цена) КАК ТоварыБезКомплектов";
	
	// Запрос по оплате
	ЗапросПоОплате = Новый Запрос;
	ЗапросПоОплате.Текст = 
	"ВЫБРАТЬ
	|	ЧекОплаты.ТипОплаты КАК ТипОплаты,
	|	СУММА(ВЫБОР
	|			КОГДА ЧекОплаты.Ссылка.ВидОперации = &ВидОперацииПродажа
	|				ТОГДА ЧекОплаты.Сумма
	|			ИНАЧЕ -ЧекОплаты.Сумма
	|		КОНЕЦ) КАК Сумма,
	|	ЧекОплаты.ВидОплаты
	|ПОМЕСТИТЬ ТаблицаОплат
	|ИЗ
	|	Документ.Чек.Оплаты КАК ЧекОплаты
	|ГДЕ
	|	ЧекОплаты.Ссылка.КассоваяСмена = &КассоваяСмена
	|	И ЧекОплаты.Ссылка.Проведен
	|	И ЧекОплаты.Ссылка.СтатусЧека = ЗНАЧЕНИЕ(Перечисление.СтатусыЧеков.Пробит)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЧекОплаты.ТипОплаты,
	|	ЧекОплаты.ВидОплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОплат.ТипОплаты,
	|	ТаблицаОплат.Сумма,
	|	ТаблицаОплат.ВидОплаты
	|ИЗ
	|	ТаблицаОплат КАК ТаблицаОплат
	|ГДЕ
	|	ТаблицаОплат.Сумма > 0";
	
	ОтменитьТранзакцию = Ложь;
	НачатьТранзакцию();
	
	РезультатЗапросаПоЧекам           = ЗапросПоЧекам.Выполнить();
	
	ОтчетОРозничныхПродажах = ПустойОтчетОРозничныхПродажах();
	ОтчетОРозничныхПродажах.КассоваяСмена = КассоваяСмена;
	
	
	Попытка
		ОтчетОРозничныхПродажах.Записать(РежимЗаписиДокумента.Запись);
		СсылкаНаОтчет = ОтчетОРозничныхПродажах.Ссылка;
		
		МассивДокументовКПроведению.Добавить(ОтчетОРозничныхПродажах);
		
		// Архивация чеков происходит только после записи отчета ККМ.
		Если НЕ ОтменитьТранзакцию Тогда
			Попытка
				МассивСсылокЧеки = РезультатЗапросаПоЧекам.Выгрузить().ВыгрузитьКолонку("Ссылка");
				
				Для Каждого ТекСсылкаЧек Из МассивСсылокЧеки Цикл
					
					ДокументОбъект = ТекСсылкаЧек.ПолучитьОбъект();
					ДокументОбъект.СтатусЧека = Перечисления.СтатусыЧеков.Архивный;
					ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
					
				КонецЦикла;
				
			Исключение
				
				ОтменитьТранзакцию = Истина;
				
				Текст = СтрЗаменить(НСтр("ru = 'Не удалось заархивировать чеки ККМ! %ОписаниеОшибки%'"), "%ОписаниеОшибки%", ОписаниеОшибки());
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
				
			КонецПопытки;
			
			
		КонецЕсли;
		
		КассоваяСменаОбъект = КассоваяСмена.ПолучитьОбъект();
		КассоваяСменаОбъект.ОкончаниеКассовойСмены = ОбщегоНазначенияКлиентСервер.ПолучитьТекущуюДату();
		КассоваяСменаОбъект.Закрыта = Истина;
		КассоваяСменаОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
	Исключение
		ОтменитьТранзакцию = Истина;
		
		Текст = СтрЗаменить(НСтр("ru = 'Не удалось записать документ ""Отчет ККМ о продажах!""%ОписаниеОшибки%'"), "%ОписаниеОшибки%", ОписаниеОшибки());
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
		
	КонецПопытки;
	
	УдалитьАннулированныеЧеки(ОтменитьТранзакцию);
	
	Если ОтменитьТранзакцию Тогда
		ОтменитьТранзакцию();
		Отказ = Истина;
	Иначе
		ЗафиксироватьТранзакцию();
		
		Для Каждого ДокументКПроведению Из МассивДокументовКПроведению Цикл
			Попытка
				РезультатПроверки = ДокументКПроведению.ПроверитьЗаполнение();
				
				Если РезультатПроверки Тогда
					ДокументКПроведению.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Оперативный);
					Если НЕ ДокументКПроведению.Проведен Тогда
						СписокНеПроведенныхДокументов.Добавить(ДокументКПроведению.Ссылка, ДокументКПроведению.Ссылка.Метаданные().Имя);
					КонецЕсли;
				Иначе
					ДокументКПроведению.Записать(РежимЗаписиДокумента.Запись);
				КонецЕсли;
			Исключение
				СписокНеПроведенныхДокументов.Добавить(ДокументКПроведению.Ссылка, ДокументКПроведению.Ссылка.Метаданные().Имя);
				НужноДополнительноеПредупреждение = Истина;
				
				Текст = СтрЗаменить(НСтр("ru = 'Не удалось провести документ ""%Документ%"".'"), "%Документ%", Строка(ДокументКПроведению));
				
				Текст = Текст + Символы.ПС + ОписаниеОшибки();
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
				
			КонецПопытки;
			
			СписокДокументов.Добавить(ДокументКПроведению.Ссылка, ДокументКПроведению.Ссылка.Метаданные().Имя);
		КонецЦикла;
	КонецЕсли;
	
	

КонецПроцедуры

Процедура ПометитьКВыгрузкеОтчетОПродажах(СсылкаНаОтчет, Результат = Ложь) Экспорт
	
	Если СсылкаНаОтчет.СтатусОбмена = Перечисления.СтатусыОбмена.ГотовКОбмену Тогда
		Возврат;
	КонецЕсли;
	
	ОтчетОПродажахОбъект = СсылкаНаОтчет.ПолучитьОбъект();
	ОтчетОПродажахОбъект.СтатусОбмена = Перечисления.СтатусыОбмена.ГотовКОбмену;
	ОтчетОПродажахОбъект.Записать();
	
	Результат = Истина;
	
КонецПроцедуры

Функция СформироватьТекстXОтчетаДляПечати(КассоваяСмена) Экспорт
	
	Если НЕ ЗначениеЗаполнено(КассоваяСмена) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеОтчета = Продажи.ОтчетПоКассе(КассоваяСмена);
	КоличествоОпераций = Продажи.ОтчетПоКассеКоличествоОпераций(КассоваяСмена);
	
	ШаблонОтчета = ШаблонXОтчетаДляПечати();
	ФорматСуммовыхПолей = ОбщегоНазначенияПовтИсп.ФорматСуммовыхПолей();
	ФорматКоличества = "ЧЦ=4; ЧН=0000; ЧВН=; ЧГ=0";
	
	ТекстXОтчета = СтрЗаменить(ШаблонОтчета, "%Продажа%",                Формат(ДанныеОтчета.Продажа,                ФорматСуммовыхПолей));
	ТекстXОтчета = СтрЗаменить(ТекстXОтчета, "%ПродажаНаличными%",       Формат(ДанныеОтчета.ПродажаНаличными,       ФорматСуммовыхПолей));
	ТекстXОтчета = СтрЗаменить(ТекстXОтчета, "%ПродажаПлатежнойКартой%", Формат(ДанныеОтчета.ПродажаПлатежнойКартой, ФорматСуммовыхПолей));
	
	ТекстXОтчета = СтрЗаменить(ТекстXОтчета, "%Возврат%",                Формат(ДанныеОтчета.Возврат,                ФорматСуммовыхПолей));
	ТекстXОтчета = СтрЗаменить(ТекстXОтчета, "%ВозвратНаличными%",       Формат(ДанныеОтчета.ВозвратНаличными,       ФорматСуммовыхПолей));
	ТекстXОтчета = СтрЗаменить(ТекстXОтчета, "%ВозвратПлатежнойКартой%", Формат(ДанныеОтчета.ВозвратПлатежнойКартой, ФорматСуммовыхПолей));
	
	ТекстXОтчета = СтрЗаменить(ТекстXОтчета, "%Внесение%",               Формат(ДанныеОтчета.Внесение,               ФорматСуммовыхПолей));
	ТекстXОтчета = СтрЗаменить(ТекстXОтчета, "%Выплата%",                Формат(ДанныеОтчета.Выплата,                ФорматСуммовыхПолей));
	
	ТекстXОтчета = СтрЗаменить(ТекстXОтчета, "%КоличествоПродаж%",       Формат(КоличествоОпераций.КоличествоПродаж,       ФорматКоличества));
	ТекстXОтчета = СтрЗаменить(ТекстXОтчета, "%КоличествоВозвратов%",    Формат(КоличествоОпераций.КоличествоВозвратов,    ФорматКоличества));
	ТекстXОтчета = СтрЗаменить(ТекстXОтчета, "%КоличествоВнесений%",     Формат(КоличествоОпераций.КоличествоВнесений,     ФорматКоличества));
	ТекстXОтчета = СтрЗаменить(ТекстXОтчета, "%КоличествоВыплат%",       Формат(КоличествоОпераций.КоличествоВыплат,       ФорматКоличества));
	
	ТекстXОтчета = СтрЗаменить(ТекстXОтчета, "%Наличные%",               Формат(ДанныеОтчета.Наличные,               ФорматСуммовыхПолей));
	ТекстXОтчета = СтрЗаменить(ТекстXОтчета, "%Выручка%",                Формат(ДанныеОтчета.Выручка,                ФорматСуммовыхПолей));
	
	Возврат ТекстXОтчета;
	
КонецФункции

Функция ПолучитьНомерСменыДляПечати(КассоваяСмена, ВыводитьСимволНомера = Истина) Экспорт
	
	Номер = ?(ЗначениеЗаполнено(КассоваяСмена.НомерСмены), КассоваяСмена.НомерСмены, КассоваяСмена.Номер);
	
	Возврат ОбщегоНазначенияКлиентСервер.ПредставлениеНомера(Номер, ВыводитьСимволНомера);
	
КонецФункции

Функция ОпределитьНеобходимостьВводаАкцизнойМарки(Номенклатура, Дата = Неопределено) Экспорт
	
	Возврат Справочники.Номенклатура.НеобходимоВводитьАкцизныеМарки(Номенклатура, Дата);
	
КонецФункции

Функция ОпределитьНеобходимостьВводаМарки(Номенклатура) Экспорт
	
	Возврат Справочники.Номенклатура.НеобходимоВводитьМарку(Номенклатура);
	
КонецФункции

Функция ОпределитьНеобходимостьШтрихкодаПриПродаже(Номенклатура, Дата = Неопределено) Экспорт
	
	Возврат Справочники.Номенклатура.ОпределитьНеобходимостьШтрихкодаПриПродаже(Номенклатура, Дата);
	
КонецФункции

Функция ПодобратьШтрихкодДляПродажи(Номенклатура, Дата = Неопределено) Экспорт
	
	Возврат Справочники.Номенклатура.ПодобратьШтрихкодДляПродажи(Номенклатура);
	
КонецФункции

Функция ПолучитьДанныеДляФискализацииЧекаСторно(ДанныеЗаполнения, СсылкаНаЧекСторно) Экспорт
	
	Если НЕ ЗначениеЗаполнено(СсылкаНаЧекСторно) Тогда
		СсылкаНаЧекСторно = СформироватьЧекСторно(ДанныеЗаполнения);
	КонецЕсли;
	
	ДанныеДляФискализацииЧека = Документы.Чек.ПолучитьДанныеДляФискализацииЧека(СсылкаНаЧекСторно, Ложь, Неопределено, Истина);
	
	Возврат ДанныеДляФискализацииЧека;
	
КонецФункции

Функция СформироватьЧекСторно(ДанныеЗаполнения)
	
	ЧекДокумент = Документы.Чек.СоздатьДокумент();
	ЧекДокумент.Заполнить(ДанныеЗаполнения.Основание);
	
	ЧекДокумент.СтатусЧека = Перечисления.СтатусыЧеков.Отложен;
	ЧекДокумент.Дата = ОбщегоНазначенияКлиентСервер.ПолучитьТекущуюДату();
	ЧекДокумент.СистемаНалогообложенияККТ = ЗначениеНастроекВызовСервераПовтИсп.СистемаНалогообложенияККТ();
	ЧекДокумент.Записать(РежимЗаписиДокумента.Запись);
	
	Возврат ЧекДокумент.Ссылка;
	
КонецФункции

#Область ЧекВозврата

Функция ПроверитьВозможностиВводаЧекаВозвратаТоваров(ЧекПродажи) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("НетТоваровКВозврату", Ложь);
	Результат.Вставить("ОдинТоварКВозврату",  Ложь);
	
	ТаблицаТоваровДляВозврата = Продажи.ПолучитьТаблицуТоваровЧекаВозврата(ЧекПродажи);
	
	Если ТаблицаТоваровДляВозврата.Количество() = 0 Тогда
		
		Результат.НетТоваровКВозврату = Истина;
	КонецЕсли;
	
	Если ТаблицаТоваровДляВозврата.Количество() = 1 
		И ТаблицаТоваровДляВозврата[0].Количество = 1 Тогда
		
		Результат.ОдинТоварКВозврату = Истина;;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьДанныеПоТоваруКВозврату(ЧекПродажи, ЧекВозврата, Номенклатура, ЦенаСУчетомСкидки) Экспорт
	
	ДанныеТовараКВозврату = Новый Структура;
	ДанныеТовараКВозврату.Вставить("МаксимальноеКоличествоКВозврату", 0);
	ДанныеТовараКВозврату.Вставить("СкидкаНаценкаСуммаПродажи", 0);
	ДанныеТовараКВозврату.Вставить("КоличествоПродажи", 0);
	ДанныеТовараКВозврату.Вставить("ЦенаСУчетомСкидки", 0);
	
	ТаблицаТоваровЧекаВозврата = Продажи.ПолучитьТаблицуТоваровЧекаВозврата(ЧекПродажи,, ЧекВозврата, Номенклатура);
	
	Если ЦенаСУчетомСкидки = Неопределено Тогда
		
		Строки = ТаблицаТоваровЧекаВозврата;
	Иначе
		
		Строки = ТаблицаТоваровЧекаВозврата.НайтиСтроки(Новый Структура("ЦенаСУчетомСкидки", ЦенаСУчетомСкидки));
	КонецЕсли;
	
	Если НЕ Строки.Количество() = 0 Тогда
		
		ДанныеТовараКВозврату.МаксимальноеКоличествоКВозврату = Строки[0].Количество;
		ДанныеТовараКВозврату.СкидкаНаценкаСуммаПродажи       = Строки[0].СкидкаНаценкаСуммаПродажи;
		ДанныеТовараКВозврату.КоличествоПродажи               = Строки[0].КоличествоПродажи;
		ДанныеТовараКВозврату.ЦенаСУчетомСкидки               = Строки[0].ЦенаСУчетомСкидки;
	КонецЕсли;
	
	Возврат ДанныеТовараКВозврату;
	
КонецФункции

Функция ПолучитьЧекПередачиТоваровПоЗаказу(Заказ) Экспорт
	
	Возврат Документы.Чек.ПолучитьЧекПередачиТоваровПоЗаказу(Заказ);
	
КонецФункции

#КонецОбласти

Функция ПолучитьИмяКассира() Экспорт
	
	Если ЗначениеНастроекВызовСервераПовтИсп.ИспользуетсяУчетПоКассирам() Тогда
		
		ТекущийКассир = ПараметрыСеанса.ТекущийПользователь;
		
		Если ЗначениеЗаполнено(ТекущийКассир) Тогда
			
			Возврат ТекущийКассир.Наименование;
		Иначе
			Возврат "";
		КонецЕсли;
		
	Иначе
		
		Возврат ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ИмяКассира");
		
	КонецЕсли;
	
КонецФункции

Функция ПолучитьДолжностьКассира() Экспорт
	
	ДолжностьКассира = "";
	
	Если ЗначениеНастроекВызовСервераПовтИсп.ИспользуетсяУчетПоКассирам() Тогда
		
		ТекущийКассир = ПараметрыСеанса.ТекущийПользователь;
		
		Если ЗначениеЗаполнено(ТекущийКассир) Тогда
			
			ДолжностьКассира =  ТекущийКассир.Должность;
			
		КонецЕсли;
		
	Иначе
		
		ДолжностьКассира = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ДолжностьКассира");
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДолжностьКассира) Тогда
		ДолжностьКассира = НСтр("ru = 'Кассир'");
	КонецЕсли;
	
	Возврат ДолжностьКассира;
	
КонецФункции

Функция ПолучитьИННКассира() Экспорт
	
	Если ЗначениеНастроекВызовСервераПовтИсп.ИспользуетсяУчетПоКассирам() Тогда
		
		ТекущийКассир = ПараметрыСеанса.ТекущийПользователь;
		
		Если ЗначениеЗаполнено(ТекущийКассир) Тогда
			
			Возврат ТекущийКассир.ИНН;
		Иначе
			Возврат Неопределено;
		КонецЕсли;
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПоследнююЗакрытуюСмену()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КассоваяСмена.Ссылка
	|ИЗ
	|	Документ.КассоваяСмена КАК КассоваяСмена
	|ГДЕ
	|	КассоваяСмена.Закрыта
	|	И КассоваяСмена.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	КассоваяСмена.Дата УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПустойОтчетОРозничныхПродажах()
	
	Отчет               = Документы.ОтчетОРозничныхПродажах.СоздатьДокумент();
	Отчет.Дата          = КонецДня(ОбщегоНазначенияКлиентСервер.ПолучитьТекущуюДату());
	
	Отчет.ЦенаВключаетНДС = ЗначениеНастроекПовтИсп.ЦенаВключаетНДС();
	Отчет.СтатусОбмена = Перечисления.СтатусыОбмена.ГотовКОбмену;
	
	Возврат Отчет;
	
КонецФункции

Процедура УдалитьАннулированныеЧеки(ОтменитьТранзакцию)
	
	ЗапросПоАннулированнымЧекам = Новый Запрос;
	ЗапросПоАннулированнымЧекам.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Док.Ссылка КАК ОтложенныйЧек
	|ИЗ
	|	Документ.Чек КАК Док
	|ГДЕ
	|	Док.Ссылка.СтатусЧека = ЗНАЧЕНИЕ(Перечисление.СтатусыЧеков.Аннулирован)";
	
	РезультатЗапросаПоАннулированнымЧекам = ЗапросПоАннулированнымЧекам.Выполнить();
	
	Если НЕ ОтменитьТранзакцию Тогда
		Попытка
			МассивСсылокАннулированныеЧеки = РезультатЗапросаПоАннулированнымЧекам.Выгрузить().ВыгрузитьКолонку("ОтложенныйЧек");
			
			Для Каждого АннулированныйЧек Из МассивСсылокАннулированныеЧеки Цикл
				АннулированныйЧекОбъект = АннулированныйЧек.ПолучитьОбъект();
				Если АннулированныйЧекОбъект.Проведен Тогда 
					АннулированныйЧекОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
				КонецЕсли;
				АннулированныйЧекОбъект.ПометкаУдаления = Истина;
				АннулированныйЧекОбъект.Записать();
				АннулированныйЧекОбъект.Удалить(); 
			КонецЦикла;
			
		Исключение
			ОтменитьТранзакцию = Истина;
			
			Текст = СтрЗаменить(НСтр("ru = 'Не удалось удалить аннулированные чеки. %ОписаниеОшибки%'"), "%ОписаниеОшибки%", ОписаниеОшибки());
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
			
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

Функция ШаблонXОтчетаДляПечати()
	
	// Для прижатия текста к правому краю используется Tab
	
	Шаблон = НСтр("ru = 'ПРОДАЖА	%Продажа%
	|  НАЛИЧНЫМИ	%ПродажаНаличными%
	|  ПЛАТ.КАРТОЙ	%ПродажаПлатежнойКартой%
	|
	|ВОЗВРАТ	%Возврат%
	|  НАЛИЧНЫМИ	%ВозвратНаличными%
	|  ПЛАТ.КАРТОЙ	%ВозвратПлатежнойКартой%
	|
	|ВНЕСЕНИЕ	%Внесение%
	|ВЫПЛАТА	%Выплата%
	|
	|ПРОДАЖ	%КоличествоПродаж%
	|ВОЗВРАТОВ	%КоличествоВозвратов%
	|ВНЕСЕНИЙ	%КоличествоВнесений%
	|ВЫПЛАТ	%КоличествоВыплат%
	|
	|НАЛИЧНОСТЬ	%Наличные%
	|ВЫРУЧКА	%Выручка%
	|'");
	
	Возврат Шаблон;
	
КонецФункции

#КонецОбласти
