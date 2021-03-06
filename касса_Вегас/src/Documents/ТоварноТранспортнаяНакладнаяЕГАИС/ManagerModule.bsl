
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекстЗаголовка = НСтр("ru = 'ТТН %ПредставлениеНомера% от %ПредставлениеДата%'");
	
	ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%ПредставлениеНомера%", ОбщегоНазначенияКлиентСервер.ПредставлениеНомера(Данные.Ссылка.НомерТТН));
	ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%ПредставлениеДата%",   Формат(Данные.Ссылка.ДатаТТН, "ДЛФ=D"));
	
	Представление = ТекстЗаголовка;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьДанныеТТН(СсылкаТТН) Экспорт
	
	ТекстТТН = СсылкаТТН.ТТНТекстXML.Получить();
	ТекстСправкаБ = СсылкаТТН.СправкаБТекстXML.Получить();
	
	Если ПустаяСтрока(ТекстТТН) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ТекстТТН);
	Фабрика = ИнтеграцияЕГАИС.ФабрикаЕГАИС();
	
	ТаблицаОрганизаций = Неопределено;
	ДанныеТТН = Неопределено;
	
	Попытка
		
		ОбъектXDTO = Фабрика.ПрочитатьXML(ЧтениеXML, Фабрика.Тип(Справочники.ВидыОбъектовЕГАИС.ДокументыЕГАИС.ПространствоИмен, "Документы"));
		ДанныеТТН = ИнтеграцияЕГАИС.ПолучитьДанныеТТН(ОбъектXDTO.Document.WayBill, ТаблицаОрганизаций);
		
	Исключение
		
		ТекстОшибки = НСтр("ru = 'Не удалось прочитать входящий документ ТТН'");
		ТекстОшибки = ТекстОшибки + Символы.ПС + ОписаниеОшибки();
		СообщениеОбОшибке = ТекстОшибки;
		
		ВызватьИсключение СообщениеОбОшибке;
		
	КонецПопытки;
	
	Если НЕ ПустаяСтрока(ТекстСправкаБ) Тогда
		
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.УстановитьСтроку(ТекстСправкаБ);
		
		Попытка
			
			ОбъектXDTO = Фабрика.ПрочитатьXML(ЧтениеXML, Фабрика.Тип(Справочники.ВидыОбъектовЕГАИС.ДокументыЕГАИС.ПространствоИмен, "Документы"));
			ДанныеСправкиБ = ИнтеграцияЕГАИС.ПолучитьДанныеСправкиБ(ОбъектXDTO.Document.TTNInformBReg, ТаблицаОрганизаций);
			
		Исключение
			
			ТекстОшибки = НСтр("ru = 'Не удалось прочитать справку Б'");
			ТекстОшибки = ТекстОшибки + Символы.ПС + ОписаниеОшибки();
			СообщениеОбОшибке = ТекстОшибки;
			
			ВызватьИсключение СообщениеОбОшибке;
		КонецПопытки;
		
		
		ДополнитьДаннымиСправкиБ(ДанныеТТН, ДанныеСправкиБ)
		
	КонецЕсли;
	
	ДанныеТТН.Вставить("Квитанции", Новый Массив());
	
	// Квитанции
	Для Каждого Квитанция Из СсылкаТТН.Квитанции Цикл
		
		ТекстXML = Квитанция.КвитанцияТекстXML.Получить();
		ДобавитьКвитанциюВДанные(ТекстXML, ДанныеТТН.Квитанции);
		
	КонецЦикла;
	
	Возврат ДанныеТТН;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДополнитьДаннымиСправкиБ(ДанныеТТН, СправкаБ)
	
	ДанныеТТН.ИдентификаторТТН = СправкаБ.ИдентификаторТТН;
	
	Для каждого СтрокаСодержимого Из СправкаБ.Содержимое Цикл
		
		ИдентификаторСтрокиСправкиБ = СтрокаСодержимого.ИдентификаторСтрокиТТН;
		
		Для каждого СтрокаТоваров Из ДанныеТТН.ТаблицаТоваров Цикл
			
			Если ИдентификаторСтрокиСправкиБ = СтрокаТоваров.ИдентификаторСтроки Тогда
				
				СтрокаТоваров.НомерСправкиБ = СтрокаСодержимого.РегистрационныйНомер;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьКвитанциюВДанные(ТекстXML, КоллекцияКвитанций)
	
	СтруктураКвитанции = Новый Структура();
	СтруктураКвитанции.Вставить("КомментарийЕГАИС");
	СтруктураКвитанции.Вставить("ОтказЕГАИС");
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ТекстXML);
	
	Попытка
		
		Фабрика = ИнтеграцияЕГАИС.ФабрикаЕГАИС();
		ОбъектXDTO = Фабрика.ПрочитатьXML(ЧтениеXML, Фабрика.Тип(Справочники.ВидыОбъектовЕГАИС.ДокументыЕГАИС.ПространствоИмен, "Документы"));
		
	Исключение
		ТекстОшибки = НСтр("ru = 'Не удалось прочитать входящую квитанцию'");
		ВызватьИсключение ТекстОшибки;
		
	КонецПопытки;
	
	Если НЕ ОбъектXDTO.Document.Ticket = Неопределено Тогда // Квитанция
		
		Если НЕ ОбъектXDTO.Document.Ticket.Result = Неопределено Тогда
			
			РезультатXDTO = ОбъектXDTO.Document.Ticket.Result;
			
			СтруктураКвитанции.ОтказЕГАИС = ВРег(РезультатXDTO.Conclusion) = ВРег("Rejected");
			СтруктураКвитанции.КомментарийЕГАИС = РезультатXDTO.Comments;
			
		ИначеЕсли НЕ ОбъектXDTO.Document.Ticket.OperationResult = Неопределено Тогда
			
			РезультатXDTO = ОбъектXDTO.Document.Ticket.OperationResult;
			
			СтруктураКвитанции.ОтказЕГАИС = ВРег(РезультатXDTO.OperationResult) = ВРег("Rejected");
			
			Если ВРег(РезультатXDTO.OperationName) = ВРег("UnConfirm") Тогда
				СтруктураКвитанции.ОтказЕГАИС = Истина;
			КонецЕсли;
			
			СтруктураКвитанции.КомментарийЕГАИС   = РезультатXDTO.OperationComment;
			
		Иначе
			
			ОписаниеОшибки = НСтр("ru = 'Не удалось определить формат квитанции'");
			СтруктураКвитанции.КомментарийЕГАИС = ОписаниеОшибки;
			СтруктураКвитанции.ОтказЕГАИС = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	КоллекцияКвитанций.Добавить(СтруктураКвитанции);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли