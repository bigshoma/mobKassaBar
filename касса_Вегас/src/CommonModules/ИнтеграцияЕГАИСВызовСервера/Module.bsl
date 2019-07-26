
#Область ПрограммныйИнтерфейс

// Функция возвращает параметры запроса документа, который нужно выгрузить в ЕГАИС.
//
// Параметры:
//  ТранспортныйМодуль  - Структура - модуль, для которого формируется текст документа,
//  ВидДокумента        - СправочникСсылка.ВидыОбъектовЕГАИС - вид документа,
//  Параметры           - Структура - параметры формирования документа.
//
// Возвращаемое значение:
//   Структура -  параметры запроса.
//
Функция ПараметрыЗапросаДокументаЕГАИС(ВидДокумента, Знач Параметры) Экспорт

	Результат = Новый Структура;
	Результат.Вставить("АдресЗапроса", ВидДокумента.ПутьНаСервере);
	Результат.Вставить("ТекстЗапроса", ИнтеграцияЕГАИС.ТекстXMLВыгрузкиДокумента(ВидДокумента, Параметры));
	
	Возврат Результат;

КонецФункции

// Загружает список документов, полученных из УТМ.
//
// Параметры:
//  МассивДокументов  - Массив - полученные документы из ТМ ЕГАИС,
//  ДополнительныеПараметры - Произвольный - параметры прикладной конфигурации.
//
// Возвращаемое значение:
//   Соответствие  - загруженные документы.
//
Функция ОбработатьВходящиеДокументы(Знач МассивДокументов, Знач ДополнительныеПараметры) Экспорт
	
	Возврат ИнтеграцияЕГАИС.ОбработатьВходящиеДокументы(МассивДокументов, ДополнительныеПараметры);
	
КонецФункции

// Записывает данные запроса в регистр сведений ЗапросыЕГАИС.
//
// Параметры:
//  ИдентификаторЗапроса - Строка - идентификатор исходящего запроса,
//  ТипЗапроса           - СправочникСсылка.ВидыОбъектовЕГАИС - вид исходящего документа,
//  ДатаЗапроса          - Дата - дата запроса.
//
Процедура ЗаписатьДанныеЗапроса(ИдентификаторЗапроса, ТипЗапроса, ДатаЗапроса = Неопределено) Экспорт
	
	Запись = РегистрыСведений.ЗапросыЕГАИС.СоздатьМенеджерЗаписи();
	Запись.Идентификатор = ИдентификаторЗапроса;
	Запись.ТипЗапроса    = ТипЗапроса;
	Запись.ДатаЗапроса   = ?(НЕ ЗначениеЗаполнено(ДатаЗапроса), ОбщегоНазначенияКлиентСервер.ПолучитьТекущуюДату(), ДатаЗапроса);
	Запись.Записать();
	
КонецПроцедуры

// Проверяет наличие исходящего запроса по идентификатору.
//
// Параметры:
//  ИдентификаторЗапроса - Строка - идентификатор исходящего запроса.
//
// Возвращаемое значение:
//   Булево - признак наличия запроса.
//
Функция ЕстьИсходящийЗапрос(ИдентификаторЗапроса) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИдентификаторЗапроса", ИдентификаторЗапроса);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ТоварноТранспортнаяНакладнаяЕГАИС.Ссылка
	|ИЗ
	|	Документ.ТоварноТранспортнаяНакладнаяЕГАИС КАК ТоварноТранспортнаяНакладнаяЕГАИС
	|ГДЕ
	|	ТоварноТранспортнаяНакладнаяЕГАИС.ИдентификаторИсходящегоЗапросаАктаПодтверждения = &ИдентификаторЗапроса";
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

// Получает электронную подпись чека ККМ.
//
// Параметры:
//  ДанныеЧека     - Структура - данные чека,
//  ТаблицаТоваров - Массив    - состав чека.
//
// Возвращаемое значение:
//   Структура - значения подписи и URL, полученные из ТМ ЕГАИС.
//
Функция ПараметрыЗапросаЧекаККМ(Знач ДанныеЧека, Знач ТаблицаТоваров) Экспорт
	
	Результат = Новый Структура;
	
	ТекстОшибки = "";
	ТекстXML = ИнтеграцияЕГАИС.ТекстXMLВыгрузкиЧека(Справочники.ВидыОбъектовЕГАИС.ЧекККМ, ДанныеЧека, ТаблицаТоваров, ТекстОшибки);
	
	Результат.Вставить("Результат"     , ПустаяСтрока(ТекстОшибки));
	Результат.Вставить("ОписаниеОшибки", ТекстОшибки);
	Результат.Вставить("АдресЗапроса"  , Справочники.ВидыОбъектовЕГАИС.ЧекККМ.ПутьНаСервере);
	Результат.Вставить("ТекстXML"      , ТекстXML);
	
	Возврат Результат;
	
КонецФункции

// Проверят использование механизма регистрации розничных продаж в ЕГАИС.
//
// Параметры:
//  ДатаПродажи  - Дата - дата, на которую нужно проверить использование регистрации продаж.
//                        Если не указана, то проверяться будет текущая дата сеанса.
//
// Возвращаемое значение:
//   Булево   - признак использования регистрации продаж.
//
Функция ИспользуетсяРегистрацияРозничныхПродажВЕГАИС(Знач ДатаПродажи = Неопределено) Экспорт

	Если НЕ ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ВыгружатьЧекиЕГАИС") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаПродажи) Тогда
		ДатаПродажи = ОбщегоНазначенияКлиентСервер.ПолучитьТекущуюДату();
	КонецЕсли;
	
	ДатаНачалаРегистрации = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ДатаНачалаВыгрузкиЧековЕГАИС");
	
	Возврат ДатаПродажи >= ДатаНачалаРегистрации И ЗначениеЗаполнено(ДатаНачалаРегистрации);

КонецФункции

Функция ВыгружатьПродажиНемаркируемойПродукцииВЕГАИС() Экспорт
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти
