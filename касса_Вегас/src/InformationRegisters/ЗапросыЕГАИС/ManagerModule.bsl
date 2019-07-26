
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Удаляет запрос из регистра сведений.
//
// Параметры:
//  Идентификатор  - Строка - идентификатор удаляемого запроса.
//
Процедура УдалитьЗапрос(Идентификатор) Экспорт

	Запись = РегистрыСведений.ЗапросыЕГАИС.СоздатьМенеджерЗаписи();
	Запись.Идентификатор = Идентификатор;
	Запись.Прочитать();
	Если Запись.Выбран() Тогда
		Запись.Удалить();
	КонецЕсли;
	
КонецПроцедуры // УдалитьЗапрос()

// Записывает ответ из ЕГАИС на запрос.
//
// Параметры:
//  Идентификатор  - Строка - идентификатор запроса,
//  ДатаОтвета     - Дата - дата ответа из ЕГАИС,
//  Комментарий    - Строка - комментарий (причина отказа) из ЕГАИС.
//
Процедура ЗаписатьОтветИзЕГАИС(Идентификатор, ДатаОтвета, Комментарий) Экспорт
	
	Запись = РегистрыСведений.ЗапросыЕГАИС.СоздатьМенеджерЗаписи();
	Запись.Идентификатор = Идентификатор;
	Запись.Прочитать();
	
	Если НЕ Запись.Выбран() Тогда
		Возврат;
	КонецЕсли;
	
	Запись.ДатаОтвета = ДатаОтвета;
	Запись.Комментарий = Комментарий;
	
	Запись.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли