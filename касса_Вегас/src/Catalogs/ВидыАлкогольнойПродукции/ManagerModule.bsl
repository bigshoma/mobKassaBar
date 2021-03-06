
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Представление = Данные.Ссылка.Код + " (" + Данные.Ссылка.Наименование + ")";
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура заполняет справочник из классификатора
//
Процедура ЗаполнитьСправочникИзКлассификатораВидовАлкогольнойПродукции() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыАлкогольнойПродукции.Ссылка
	|ИЗ
	|	Справочник.ВидыАлкогольнойПродукции КАК ВидыАлкогольнойПродукции";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаВидов = КлассификаторВидовАлкогольнойПродукции();
	
	Для Каждого Вид Из ТаблицаВидов Цикл
		
		НовыйЭлемент = Справочники.ВидыАлкогольнойПродукции.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(НовыйЭлемент, Вид, "Код, Наименование, Маркируемый");
		
		НовыйЭлемент.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьСправочникИзКлассификатораВидовАлкогольнойПродукции() Экспорт
	
	ТаблицаВидов = КлассификаторВидовАлкогольнойПродукции();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаВидов.Код,
	|	ТаблицаВидов.Наименование,
	|	ТаблицаВидов.Маркируемый
	|ПОМЕСТИТЬ ТаблицаВидов
	|ИЗ
	|	&ТаблицаВидов КАК ТаблицаВидов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидов.Код,
	|	ТаблицаВидов.Наименование,
	|	ТаблицаВидов.Маркируемый,
	|	ЕСТЬNULL(ВидыАлкогольнойПродукции.Ссылка, ЗНАЧЕНИЕ(Справочник.ВидыАлкогольнойПродукции.ПустаяСсылка)) КАК Ссылка
	|ИЗ
	|	ТаблицаВидов КАК ТаблицаВидов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыАлкогольнойПродукции КАК ВидыАлкогольнойПродукции
	|		ПО ТаблицаВидов.Код = ВидыАлкогольнойПродукции.Код";
		
		
	Запрос.УстановитьПараметр("ТаблицаВидов", ТаблицаВидов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если ЗначениеЗаполнено(Выборка.Ссылка) Тогда
			
			ЭлементСправочника = Выборка.Ссылка.ПолучитьОбъект();
			ЗаполнитьЗначенияСвойств(ЭлементСправочника, Выборка, "Наименование, Маркируемый");
			
		Иначе
			
			ЭлементСправочника = Справочники.ВидыАлкогольнойПродукции.СоздатьЭлемент();
			ЗаполнитьЗначенияСвойств(ЭлементСправочника, Выборка, "Код, Наименование, Маркируемый");
			
		КонецЕсли;
		
		ЭлементСправочника.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция возвращает таблицу значений классификатора видов алкогольной продукции.
//
Функция КлассификаторВидовАлкогольнойПродукции()
	
	ТаблицаВидовПродукции = Новый ТаблицаЗначений;
	
	Макет = Справочники.ВидыАлкогольнойПродукции.ПолучитьМакет("КлассификаторВидовАлкогольнойПродукции");
	
	ТекстМакета = Макет.ТекущаяОбласть.Текст;
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ТекстМакета);
	
	Если Не ЧтениеXML.Прочитать() Тогда
		ВызватьИсключение НСтр("ru = 'Пустой XML'");
	ИначеЕсли ЧтениеXML.Имя <> "Items" Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка в структуре XML'");
	КонецЕсли;
	
	ИменаКолонок = СтрЗаменить(ЧтениеXML.ПолучитьАтрибут("Columns"), ",", Символы.ПС);
	КоличествоКолонок = СтрЧислоСтрок(ИменаКолонок);
	
	Для Сч = 1 По КоличествоКолонок Цикл
		ИмяКолонки = СтрПолучитьСтроку(ИменаКолонок, Сч);
		
		Если ИмяКолонки = "Маркируемый" Тогда
			ТаблицаВидовПродукции.Колонки.Добавить(ИмяКолонки, Новый ОписаниеТипов("Булево"));
		ИначеЕсли ИмяКолонки = "Код" Тогда
			ТаблицаВидовПродукции.Колонки.Добавить(ИмяКолонки,  Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(3)));
		Иначе
			ТаблицаВидовПродукции.Колонки.Добавить(ИмяКолонки, Новый ОписаниеТипов("Строка"));
		КонецЕсли;
	КонецЦикла;
	
	Пока ЧтениеXML.Прочитать() Цикл
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента И ЧтениеXML.Имя = "Items" Тогда
			Прервать;
		ИначеЕсли ЧтениеXML.ТипУзла <> ТипУзлаXML.НачалоЭлемента Тогда
			Продолжить;
		ИначеЕсли ЧтениеXML.Имя <> "Item" Тогда
			ВызватьИсключение НСтр("ru = 'Ошибка в структуре XML'");
		КонецЕсли;
		
		новСтр = ТаблицаВидовПродукции.Добавить();
		Для Сч = 1 По КоличествоКолонок Цикл
			ИмяКолонки = СтрПолучитьСтроку(ИменаКолонок, Сч);
			
			Если ИмяКолонки = "Маркируемый" Тогда
				новСтр[Сч-1] = Булево(Число(ЧтениеXML.ПолучитьАтрибут(ИмяКолонки)));
			Иначе
				новСтр[Сч-1] = ЧтениеXML.ПолучитьАтрибут(ИмяКолонки);
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	ТаблицаВидовПродукции.Сортировать(ТаблицаВидовПродукции.Колонки[0].Имя + " Возр");
	
	Возврат ТаблицаВидовПродукции;
	
КонецФункции // КлассификаторВидовАлкогольнойПродукции()

#КонецОбласти

#КонецЕсли