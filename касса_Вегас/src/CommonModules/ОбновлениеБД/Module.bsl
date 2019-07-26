
#Область ПрограммныйИнтерфейс

Функция ОпределитьНеобходимостьОбновления() Экспорт
	
	СписокОбработчиковОбновления = ПолучитьСписокОбработчиковОбновленияТекущейВерсии();
	
	Возврат НЕ СписокОбработчиковОбновления.Количество() = 0;
	
КонецФункции

Процедура ОбновитьБазуДанных(Отказ, Лог) Экспорт
	
	НоваяВерсияПриложения = Метаданные.Версия;
	
	СписокОбработчиков = ПолучитьСписокОбработчиковОбновленияТекущейВерсии();
	
	Попытка
		
		Для Каждого Обработчик Из СписокОбработчиков Цикл
			
			Если Обработчик = "2.0.3" Тогда
				
				ВыполнитьОбновление2_0_3(Лог);
				
			ИначеЕсли Обработчик = "2.6.1" Тогда
				
				ВыполнитьОбновление2_6_1(Лог);
				
			ИначеЕсли Обработчик = "2.11.1" Тогда
				
				ВыполнитьОбновление2_11_1(Лог);
				
			ИначеЕсли Обработчик = "2.14.4" Тогда
				
				ВыполнитьОбновление2_14_4(Лог);
				
			ИначеЕсли Обработчик = "2.16.1" Тогда
				
				ВыполнитьОбновление2_16_1(Лог);
				
			ИначеЕсли Обработчик = "2.16.6" Тогда
				
				ВыполнитьОбновление2_16_6(Лог);
				
			ИначеЕсли Обработчик = "2.24.1" Тогда
				
				ВыполнитьОбновление2_24_1(Лог);
			
			КонецЕсли;
			
		КонецЦикла;
		
		Константы.ТекущаяВерсияПриложения.Установить(НоваяВерсияПриложения);
		ОбновитьПовторноИспользуемыеЗначения();
		
	Исключение
		
		Отказ = Истина;
		Лог = ОписаниеОшибки();
		
	КонецПопытки;
	
	ПараметрыСеанса.ОбновлениеБД = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыОбновления

Процедура ВыполнитьОбновление2_0_3(Лог)
	
	// ЗагружатьНастройки
	ВидТранспортаСообщенийОбмена = Константы.ВидТранспортаСообщенийОбмена.Получить();
	
	Если ВидТранспортаСообщенийОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.FILE Тогда
		
		Если ЗначениеЗаполнено(Константы.ИмяФайлаНастроек.Получить()) Тогда
			Константы.ЗагружатьНастройки.Установить(Истина);
		КонецЕсли;
		
	ИначеЕсли ВидТранспортаСообщенийОбмена = Перечисления.ВидыТранспортаСообщенийОбмена.WS Тогда
		Константы.ЗагружатьНастройки.Установить(Истина);
		
		// АдресWS
		ОбщегоНазначенияВызовСервера.СохранитьНастройкуПользователя("ВидАдресаПодключенияWS", 1);
	КонецЕсли;
	
	// ИНН
	// НаименованиеОрганизации
	// СистемаНалогообложения
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Организации.СистемаНалогообложения,
	|	Организации.ИНН,
	|	Организации.Наименование
	|ИЗ
	|	Справочник.УдалитьОрганизации КАК Организации";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Константы.ИНН.Установить(Выборка.ИНН);
		Константы.НаименованиеОрганизации.Установить(Выборка.Наименование);
		Константы.СистемаНалогообложения.Установить(Выборка.СистемаНалогообложения);
	КонецЕсли;
	
	
	// Цены номенклатуры
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УдалитьЦеныНоменклатуры.Номенклатура КАК Номенклатура,
	|	УдалитьЦеныНоменклатуры.Цена КАК Цена
	|ИЗ
	|	РегистрСведений.УдалитьЦеныНоменклатуры КАК УдалитьЦеныНоменклатуры";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ОбъектНоменклатура = Выборка.Номенклатура.ПолучитьОбъект();
		ОбъектНоменклатура.Цена = Выборка.Цена;
		ОбъектНоменклатура.Записать();
	КонецЦикла;
	
	// Чеки
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Чек.Ссылка
	|ИЗ
	|	Документ.Чек КАК Чек";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ЕстьИзменение = Ложь;
		
		ЧекОбъект = Выборка.Ссылка.ПолучитьОбъект();
		
		Товары = ЧекОбъект.Товары;
		
		Для Каждого Строка Из Товары Цикл
			Если ЗначениеЗаполнено(Строка.УдалитьСуммаСНДС) Тогда
				Строка.Сумма = Строка.УдалитьСуммаСНДС;
				ЕстьИзменение = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Если ЕстьИзменение Тогда
			ЧекОбъект.Записать(РежимЗаписиДокумента.Проведение);
		КонецЕсли;
	КонецЦикла;
	
	// ВнесениеИзъятиеНаличных
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВнесениеИзъятиеНаличных.Ссылка
	|ИЗ
	|	Документ.ВнесениеИзъятиеНаличных КАК ВнесениеИзъятиеНаличных";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ВнесениеИзъятиеНаличныхОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ВнесениеИзъятиеНаличныхОбъект.Записать(РежимЗаписиДокумента.Проведение);
	КонецЦикла;
	
КонецПроцедуры

Процедура ВыполнитьОбновление2_6_1(Лог)
	
	Справочники.ВидыАлкогольнойПродукции.ОбновитьСправочникИзКлассификатораВидовАлкогольнойПродукции();
	
	ОбновитьКодВидаАлкогольнойПродукцииВПрайсЛисте();
	
КонецПроцедуры

Процедура ВыполнитьОбновление2_11_1(Лог)
	
	ОбновитьРабочееМестоПодключаемогоОборудования();
	
КонецПроцедуры

Процедура ВыполнитьОбновление2_14_4(Лог)
	
	Константы.СпособФорматноЛогическогоКонтроля.Установить(Перечисления.СпособыФорматноЛогическогоКонтроля.РазделятьСтроки);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура.Ссылка
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	НЕ Номенклатура.ЭтоГруппа
		|	И Номенклатура.ПризнакПредметаРасчета = ЗНАЧЕНИЕ(Перечисление.ПризнакиПредметаРасчета.ПустаяСсылка)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоменклатураОбъект = Выборка.Ссылка.ПолучитьОбъект();
		НоменклатураОбъект.ПризнакПредметаРасчета = Перечисления.ПризнакиПредметаРасчета.Товар;
		
		Попытка
			НоменклатураОбъект.Записать();
		Исключение
			
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВыполнитьОбновление2_16_1(Лог)
	
	// обновление Чек - СуммаНДС, ПризнакСпособаРасчета
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Чек.Ссылка
	|ИЗ
	|	Документ.Чек КАК Чек";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ЧекОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ЧекОбъект.СуммаНДСДокумента = ЧекОбъект.Товары.Итог("СуммаНДС");
		
		Если НЕ ЗначениеЗаполнено(ЧекОбъект.ПризнакСпособаРасчета) Тогда
			ЧекОбъект.ПризнакСпособаРасчета = Перечисления.ПризнакиСпособаРасчета.ПередачаСПолнойОплатой;
		КонецЕсли;
		
		ЧекОбъект.Записать();
		
	КонецЦикла;
	
	// движения по регистру РасчетыСКлиентами
		
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Чек.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.Чек КАК Чек
	|ГДЕ
	|	Чек.Проведен
	|	И НЕ Чек.ЗаказКлиента = ЗНАЧЕНИЕ(Документ.ЗаказКлиента.ПустаяСсылка)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ДополнительныеСвойства = Новый Структура;
		ДополнительныеСвойства.Вставить("ТаблицыДляДвижений", Новый Структура);
		
		Документы.Чек.ИнициализироватьДанныеДокумента(Выборка.Ссылка, ДополнительныеСвойства);
		
		ДвиженияДокументаПоРегистру(
			"РасчетыСКлиентами",
			Выборка.Ссылка,
			ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРасчетыСКлиентами
		);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВыполнитьОбновление2_16_6(Лог)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЧекТовары.Ссылка КАК Чек,
	|	ЧекТовары.Ссылка.ЦенаВключаетНДС КАК ЦенаВключаетНДС
	|ИЗ
	|	Документ.Чек.Товары КАК ЧекТовары
	|ГДЕ
	|	ЧекТовары.СтавкаНДС = ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Чек = Выборка.Чек.ПолучитьОбъект();
		
		Для Каждого ПозицияТовара Из Чек.Товары Цикл
			
			Если Выборка.ЦенаВключаетНДС Тогда
				ПозицияТовара.СтавкаНДС = ПозицияТовара.Номенклатура.СтавкаНДС;
			Иначе
				ПозицияТовара.СтавкаНДС = Перечисления.СтавкиНДС.БезНДС;
			КонецЕсли;
			
		КонецЦикла;
		
		Чек.Записать(РежимЗаписиДокумента.Проведение);
	КонецЦикла;
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтчетОРозничныхПродажах.Ссылка КАК ОтчетОПродажах
	|ИЗ
	|	Документ.ОтчетОРозничныхПродажах КАК ОтчетОРозничныхПродажах
	|ГДЕ
	|	НЕ ОтчетОРозничныхПродажах.Проведен";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ОтчетОПродажах = Выборка.ОтчетОПродажах.ПолучитьОбъект();
		
		ОтчетОПродажах.Записать(РежимЗаписиДокумента.Проведение);
	КонецЦикла;
	
КонецПроцедуры

Процедура ВыполнитьОбновление2_24_1(Лог)
	
	Константы.ИспользоватьОплатуНаличными.Установить(Истина);
	
КонецПроцедуры

Процедура ОбновитьКодВидаАлкогольнойПродукцииВПрайсЛисте()
	
	Если НЕ ЗначениеНастроекВызовСервераПовтИсп.ЭтоАвтономныйРежим() Тогда
		
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Номенклатура.Ссылка КАК Номенклатура,
		|	Номенклатура.ВидАлкогольнойПродукции.Код КАК КодВида
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	НЕ Номенклатура.ВидАлкогольнойПродукции = ЗНАЧЕНИЕ(Справочник.ВидыАлкогольнойПродукции.ПустаяСсылка)
		|	И НЕ Номенклатура.КодВидаАлкогольнойПродукции = Номенклатура.ВидАлкогольнойПродукции.Код";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоменклатураОбъект = Выборка.Номенклатура.ПолучитьОбъект();
		НоменклатураОбъект.КодВидаАлкогольнойПродукции = Выборка.КодВида;
		НоменклатураОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьРабочееМестоПодключаемогоОборудования()
	
	РабочееМестоКлиента = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПодключаемоеОборудование.Ссылка
		|ИЗ
		|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ОборудованиеОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ОборудованиеОбъект.РабочееМесто = РабочееМестоКлиента;
		ОборудованиеОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДвиженияДокументаПоРегистру(ИмяРегистра, ДокументСсылка, ТаблицыДляДвижений)
	
	НаборЗаписей = РегистрыНакопления[ИмяРегистра].СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Регистратор.Установить(ДокументСсылка);
	
	НаборЗаписей.Загрузить(ТаблицыДляДвижений);
	
	ПерезаписатьДанныеРегистров(НаборЗаписей);
	
КонецПроцедуры

// Перезаписывает данные регистров изменения в переданном объекте.
// Для использования в обработчиках обновления.
//
// Параметры:
//   Данные                            - Произвольный - объект, набор записей или менеджер константы, который
//                                                      необходимо записать.
//   РегистрироватьНаУзлахПлановОбмена - Булево       - включает регистрацию на узлах планов обмена при записи объекта.
//   ВключитьБизнесЛогику              - Булево       - включает бизнес-логику при записи объекта.
//
Процедура ПерезаписатьДанныеРегистров(Знач Данные, Знач РегистрироватьНаУзлахПлановОбмена = Ложь, 
	Знач ВключитьБизнесЛогику = Ложь)
	
	Данные.ОбменДанными.Загрузка = Не ВключитьБизнесЛогику;
	Если Не РегистрироватьНаУзлахПлановОбмена Тогда
		Данные.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
		Данные.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
	КонецЕсли;
	
	Данные.Записать(Истина);
	
КонецПроцедуры

// Сравнить две строки версий.
//
// Параметры:
//  СтрокаВерсии1  - Строка - номер версии в формате РР.{П|ПП}.ЗЗ.
//  СтрокаВерсии2  - Строка - второй сравниваемый номер версии.
//
// Возвращаемое значение:
//   Число   - больше 0, если СтрокаВерсии1 > СтрокаВерсии2; 0, если версии равны.
//
Функция СравнитьВерсии(Знач СтрокаВерсии1, Знач СтрокаВерсии2)
	
	Строка1 = ?(ПустаяСтрока(СтрокаВерсии1), "0.0.0", СтрокаВерсии1);
	Строка2 = ?(ПустаяСтрока(СтрокаВерсии2), "0.0.0", СтрокаВерсии2);
	
	Версия1 = СтрРазделить(Строка1, ".");
	Если Версия1.Количество() <> 3 Тогда
		ВызватьИсключение ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неправильный формат параметра СтрокаВерсии1: %1'"), СтрокаВерсии1);
	КонецЕсли;
	
	Версия2 = СтрРазделить(Строка2, ".");
	Если Версия2.Количество() <> 3 Тогда
		
		ВызватьИсключение ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неправильный формат параметра СтрокаВерсии2: %1'"), СтрокаВерсии2);
	КонецЕсли;
	
	Результат = 0;
	
	Для Разряд = 0 По 2 Цикл
		Результат = Число(Версия1[Разряд]) - Число(Версия2[Разряд]);
		Если Результат <> 0 Тогда
			Возврат Результат;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция СписокОбработчиковОбновления()
	
	СписокОбработчиков = Новый Массив;
	СписокОбработчиков.Добавить("2.0.3");
	СписокОбработчиков.Добавить("2.6.1");
	СписокОбработчиков.Добавить("2.11.1");
	СписокОбработчиков.Добавить("2.14.4");
	СписокОбработчиков.Добавить("2.16.1");
	СписокОбработчиков.Добавить("2.16.6");
	СписокОбработчиков.Добавить("2.24.1");
	
	Возврат СписокОбработчиков;
	
КонецФункции

Функция ПолучитьСписокОбработчиковОбновленияТекущейВерсии()
	
	СписокОбработчиковОбновления = Новый Массив;
	
	ТекущаяВерсия = ЗначениеНастроекВызовСервераПовтИсп.ТекущаяВерсияПриложения();
	СписокОбработчиков = СписокОбработчиковОбновления();
	
	Для Каждого Обработчик Из СписокОбработчиков Цикл
		
		Если СравнитьВерсии(ТекущаяВерсия, Обработчик) < 0 Тогда
			
			СписокОбработчиковОбновления.Добавить(Обработчик);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СписокОбработчиковОбновления;
	
КонецФункции

#КонецОбласти