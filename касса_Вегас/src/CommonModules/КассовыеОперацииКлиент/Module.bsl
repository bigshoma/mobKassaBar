
Процедура ВыполнитьОтчетОТекущемСостоянииРасчетов(Форма, ОписаниеОповещение = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	Если ОписаниеОповещение = Неопределено Тогда
		ОписаниеПриЗакрытии = Новый ОписаниеОповещения("ПослеЗакрытияОтчетаОТекущемСостоянииРасчетов", ЭтотОбъект);
	Иначе
		ОписаниеПриЗакрытии = ОписаниеОповещение;
	КонецЕсли;
	
	ОткрытьФорму("Обработка.КассовыеОперации.Форма.ОтчетОТекущемСостоянииРасчетов", ПараметрыФормы, Форма,,,, ОписаниеПриЗакрытии);
	
КонецПроцедуры

Процедура ПослеЗакрытияОтчетаОТекущемСостоянииРасчетов(Результат, ДополнительныеПараметры) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ПоказатьПараметрыККТ(Форма) Экспорт
	
	ПараметрыФормы = Новый Структура;
	
	ОткрытьФорму("Обработка.КассовыеОперации.Форма.ПараметрыККТ", ПараметрыФормы, Форма);
	
КонецПроцедуры

Процедура ПоказатьСостояниеККТ(Форма) Экспорт
	
	ПараметрыФормы = Новый Структура;
	
	ОткрытьФорму("Обработка.КассовыеОперации.Форма.СостояниеККТ", ПараметрыФормы, Форма);
	
КонецПроцедуры

Процедура ПоказатьСлужебныеОперации(Форма) Экспорт
	
	ПараметрыФормы = Новый Структура;
	
	ОткрытьФорму("Обработка.КассовыеОперации.Форма.СлужебныеОперации", ПараметрыФормы, Форма);
	
КонецПроцедуры

