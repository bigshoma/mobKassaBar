
Процедура ЗапуститьОбменВФоне() Экспорт
	
	Если НЕ ПараметрыСинхронизацииВФоне.ИдентификаторЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСинхронизацииВФоне.ИдентификаторЗадания = СинхронизацияВызовСервера.ЗапуститьОбменВФоне();
	ПараметрыСинхронизацииВФоне.ЗагрузкаПрайсЛиста = Ложь;
	ПараметрыСинхронизацииВФоне.Выполняется = Истина;
	ПараметрыСинхронизацииВФоне.ТекстОшибки = "";
	ПараметрыСинхронизацииВФоне.Успешно = Ложь;
	ПараметрыСинхронизацииВФоне.ОбменИнициализирован = Истина;
	
	ПодключитьОбработчикОжиданияФоновогоОбмена();
	
	ПомощникUIКлиент.ПоказатьПроцессСинхронизации(НСтр("ru = 'Синхронизация'"), НСтр("ru = 'выполняется'"));
	ПомощникUIКлиент.ПоказатьСообщение(НСтр("ru = 'Выполняется синхронизация'"));
	
	Оповестить("СинхронизацияВФоне_Старт");
	
КонецПроцедуры

Процедура ЗапуститьЗагрузкуПрайсЛистаВФоне() Экспорт
	
	Если НЕ ПараметрыСинхронизацииВФоне.ИдентификаторЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторЗадания = СинхронизацияВызовСервера.ЗапуститьОбменВФоне();
	
	ПараметрыСинхронизацииВФоне.ИдентификаторЗадания = ИдентификаторЗадания;
	ПараметрыСинхронизацииВФоне.ЗагрузкаПрайсЛиста = Истина;
	ПараметрыСинхронизацииВФоне.Выполняется = Истина;
	ПараметрыСинхронизацииВФоне.ТекстОшибки = "";
	ПараметрыСинхронизацииВФоне.Успешно = Ложь;
	ПараметрыСинхронизацииВФоне.ОбменИнициализирован = Истина;
	
	ПодключитьОбработчикОжиданияФоновогоОбмена();
	
	ПомощникUIКлиент.ПоказатьПроцессСинхронизации(НСтр("ru = 'Синхронизация'"), НСтр("ru = 'загрузка прайс-листа'"));
	ПомощникUIКлиент.ПоказатьСообщение(НСтр("ru = 'Выполняется загрузка прайс-листа'"));
	
	Оповестить("СинхронизацияВФоне_Старт");
	
КонецПроцедуры


Процедура ОбработатьОпросФоновогоЗадания() Экспорт
	
	ИдентификаторЗаданияВФоне = ПараметрыСинхронизацииВФоне.ИдентификаторЗадания;
	
	Состояние = ОбщегоНазначенияВызовСервера.ПолучитьСостояниеФоновогоЗадания(ИдентификаторЗаданияВФоне);
	
	Если Состояние = "Завершено" Тогда
		
		ПомощникUIКлиент.ПоказатьПроцессСинхронизации(НСтр("ru = 'Синхронизация'"), НСтр("ru = 'выполнена'"), Ложь, 100);
		
		Если ПараметрыСинхронизацииВФоне.ЗагрузкаПрайсЛиста Тогда
			
			ПомощникUIКлиент.ПоказатьСообщение(НСтр("ru = 'Загрузка прайс-листа выполнена'"));
			
		Иначе
			
			ПомощникUIКлиент.ПоказатьСообщение(НСтр("ru = 'Синхронизация выполнена'"));
			
		КонецЕсли;
		
		ПомощникUIКлиент.СкрытьПроцессСинхронизации();
		
		ПараметрыСинхронизацииВФоне.ИдентификаторЗадания = Неопределено;
		
		ПараметрыСинхронизацииВФоне.ТекстОшибки = "";
		ПараметрыСинхронизацииВФоне.Успешно = Истина;
		ПараметрыСинхронизацииВФоне.Выполняется = Ложь;
		
		Оповестить("СинхронизацияВФоне_Завершено");
		
		Оповестить("ВыполненОбмен");
		
	ИначеЕсли Состояние = "Активно" Тогда
		
		ПодключитьОбработчикОжиданияФоновогоОбмена();
		
		ПараметрыСинхронизацииВФоне.ТекстОшибки = "";
		ПараметрыСинхронизацииВФоне.Успешно = Ложь;
		ПараметрыСинхронизацииВФоне.Выполняется = Истина;
		
	ИначеЕсли Состояние = "ЗавершеноАварийно" ИЛИ "Отменено" Тогда
		
		СообщениеОбОшибке = ОбщегоНазначенияВызовСервера.ПолучитьСообщениеОбОшибке(ИдентификаторЗаданияВФоне);
		
		ПомощникUIКлиент.ПоказатьОшибкуПроцессаСинхронизации(НСтр("ru = 'Синхронизация'"), НСтр("ru = 'ошибка'"));
		
		Если ПараметрыСинхронизацииВФоне.ЗагрузкаПрайсЛиста Тогда
			ПомощникUIКлиент.ПоказатьСообщение(НСтр("ru = 'Ошибка при загрузке прайс-листа'"));
		Иначе
			ПомощникUIКлиент.ПоказатьСообщение(НСтр("ru = 'Ошибка при синхронизации'"));
		КонецЕсли;
		
		ПараметрыСинхронизацииВФоне.ИдентификаторЗадания = Неопределено;
		
		ПараметрыСинхронизацииВФоне.ТекстОшибки = СообщениеОбОшибке;
		ПараметрыСинхронизацииВФоне.Успешно = Ложь;
		ПараметрыСинхронизацииВФоне.Выполняется = Ложь;
		
		Оповестить("СинхронизацияВФоне_Ошибка", СообщениеОбОшибке);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодключитьОбработчикОжиданияФоновогоОбмена()
	
	ПодключитьОбработчикОжидания("Подключаемый_ОпроситьФоновоеЗаданиеОбмена", 5, Истина);
	
КонецПроцедуры

