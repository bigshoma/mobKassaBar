// ПодключаемоеОборудование
Перем глПодключаемоеОборудование Экспорт; // для кэширования на клиенте
// Конец ПодключаемоеОборудование

Перем ПараметрыСинхронизацииВФоне Экспорт;

#Область ОбработчикиСобытий

Процедура ПриНачалеРаботыСистемы()
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПриНачалеРаботыСистемы();
	// Конец ПодключаемоеОборудование
	
	
	// ПомощникUI
	ПомощникUIКлиент.Инициализировать();
	// Конец ПомощникUI
	
	
	
	ПараметрыСинхронизацииВФоне = Новый Структура;
	ПараметрыСинхронизацииВФоне.Вставить("ИдентификаторЗадания");
	ПараметрыСинхронизацииВФоне.Вставить("ЗагрузкаПрайсЛиста", Ложь);
	ПараметрыСинхронизацииВФоне.Вставить("Успешно", Ложь);
	ПараметрыСинхронизацииВФоне.Вставить("ТекстОшибки", "");
	ПараметрыСинхронизацииВФоне.Вставить("Выполняется", Ложь);
	ПараметрыСинхронизацииВФоне.Вставить("ОбменИнициализирован", Ложь);
	
	ЛогированиеКлиент.УстановитьПутьКФайлуЛога();
	
КонецПроцедуры

Процедура ПриЗавершенииРаботыСистемы()
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПередЗавершениемРаботыСистемы();
	// Конец ПодключаемоеОборудование
	
	ПомощникUIКлиент.СкрытьПроцессСинхронизации();
	
КонецПроцедуры

Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)
	
	// Подготовить данные
	ОписаниеСобытия = Новый Структура();
	ОписаниеСобытия.Вставить("Источник", Источник);
	ОписаниеСобытия.Вставить("Событие",  Событие);
	ОписаниеСобытия.Вставить("Данные",   Данные);
	// Передать на обработку данные.
	МенеджерОборудованияКлиент.ОбработатьСобытиеОтУстройства(ОписаниеСобытия);
	
КонецПроцедуры

Процедура ПередНачаломРаботыСистемы(Отказ)
	
	ОбщегоНазначенияКлиент.ПередНачаломРаботыСистемы(Отказ);
	
КонецПроцедуры

Процедура Подключаемый_НастроитьРежимСинхронизации() Экспорт
	
	ПараметрыФормы = Новый Структура("ПервыйЗапуск", Истина);
	ОткрытьФорму("Обработка.НастройкиПриложения.Форма.РежимСинхронизации", ПараметрыФормы,,,,,,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

Процедура Подключаемый_ОпроситьФоновоеЗаданиеОбмена() Экспорт
	
	СинхронизацияКлиент.ОбработатьОпросФоновогоЗадания();
	
КонецПроцедуры

#КонецОбласти