
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначения.ВосстановитьНастройкуПользователя(Перечисления.НастройкиПользователя.ЕГАИСПериодСпискаТТН, Период);
	
	ОбщегоНазначения.УстановитьЦветИнформационныхНадписей(ЭтаФорма, "ИнфоНадписьПериод");
	
	НастроитьФормуПоЗначениямНастроек();
	
	// ОриентацияЭкрана
	НастроитьФормуПоОриентацииЭкрана();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьОтборПоПериоду();
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПараметровЭкрана()
	
	// ОриентацияЭкрана
	ПриИзмененииПараметровЭкранаСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыЗначенияНастроек" Тогда
		
		НастроитьФормуПоЗначениямНастроек();
		
	ИначеЕсли ИмяСобытия = "ЗаписанаНакладнаяЕГАИС" Тогда
		
		Если ТипЗнч(Параметр) = Тип("ДокументСсылка.ТоварноТранспортнаяНакладнаяЕГАИС") Тогда
			
			СписокИзмененныхТТН.Очистить();
			СписокИзмененныхТТН.Добавить(Параметр);
			
			Элементы.СписокТТН.ТекущаяСтрока = Параметр;
			
			УстановитьУсловноеОформление();
			
			ИнтервалСек = 5;
			ПодключитьОбработчикОжидания("Подключаемый_ОчиститьСписокИзмененныхТТН", ИнтервалСек);
			
			Элементы.СписокТТН.Обновить();
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ОбновитьСписокТТН_ЕГАИС" Тогда
		
		Если ТипЗнч(Параметр) = Тип("Массив") Тогда
			
			Для Каждого ЗагруженнаяИзмененнаяТТН Из Параметр Цикл
				
				СписокИзмененныхТТН.Добавить(ЗагруженнаяИзмененнаяТТН);
				
			КонецЦикла;
			
			Если НЕ Параметр.Количество() = 0 Тогда
				Элементы.СписокТТН.ТекущаяСтрока = Параметр[Параметр.Количество()-1];
			КонецЕсли;
			
			УстановитьУсловноеОформление();
			
			ИнтервалСек = 5;
			ПодключитьОбработчикОжидания("Подключаемый_ОчиститьСписокИзмененныхТТН", ИнтервалСек);
			
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	#Если МобильноеПриложениеКлиент Тогда
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	#КонецЕсли
	
	ОбщегоНазначенияВызовСервера.СохранитьНастройкуПользователя("ЕГАИСПериодСпискаТТН", Период);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура СписокТТНВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.СписокТТН.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ТекущиеДанные.Ссылка);
	
	ОткрытьФорму("Документ.ТоварноТранспортнаяНакладнаяЕГАИС.Форма.ФормаДокумента",
		ПараметрыФормы, ЭтотОбъект,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
	);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьТТН(Команда)
	
	Результат = ИнтеграцияЕГАИСКлиент.ЗагрузитьТТН();
	
	Если НЕ Результат.Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ОписаниеОшибки);
		Возврат;
	КонецЕсли;
	
	ОтветыИзЕГАИС = ИнтеграцияЕГАИСКлиент.ОбработатьОтветыИзЕГАИС();
	
	ТекстСообщения = НСтр("ru = 'Загрузка завершена.
								|ТТН: %ЗагруженоДокументов%
								|Ответы ЕГАИС: %ЗагруженоОтветов%'");
								
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЗагруженоДокументов%", Результат.ЗагруженоДокументов);
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЗагруженоОтветов%", ОтветыИзЕГАИС.ЗагруженоДокументов);
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
	Элементы.СписокТТН.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПериод(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ОповещениеУстановитьПериод", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Период", Период);
	
	ОткрытьФорму("ОбщаяФорма.НастройкаПериода", ПараметрыФормы, ЭтаФорма,,,, Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьФормуПоЗначениямНастроек()
	
	ОбщегоНазначения.УстановитьШрифт(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОчиститьСписокИзмененныхТТН()
	
	СписокИзмененныхТТН.Очистить();
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеУстановитьПериод(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено ИЛИ Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементОтбораСписка(СписокТТН, "ДатаТТН");
	
	Если Результат = "ОчиститьПериод" Тогда
		Период = Неопределено;
	Иначе
		Период = Результат;
	КонецЕсли;
	
	УстановитьОтборПоПериоду();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоПериоду()
	
	ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(
		СписокТТН,
		"ДатаТТН",
		Период.ДатаНачала,
		ЗначениеЗаполнено(Период.ДатаНачала),
		ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
	
	ОбщегоНазначенияКлиентСервер.ИзменитьЭлементОтбораСписка(
		СписокТТН,
		"ДатаТТН",
		Период.ДатаОкончания,
		ЗначениеЗаполнено(Период.ДатаОкончания),
		ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,
		Ложь);
	
	Если ЗначениеЗаполнено(Период) Тогда
		
		ФорматДаты = "ДФ=dd.MM.yy";
		ИнфоНадпись = НСтр("ru = '%ДатаНачала% - %ДатаОкончания%'");
		ИнфоНадпись = СтрЗаменить(ИнфоНадпись, "%ДатаНачала%", Формат(Период.ДатаНачала, ФорматДаты));
		ИнфоНадпись = СтрЗаменить(ИнфоНадпись, "%ДатаОкончания%", Формат(Период.ДатаОкончания, ФорматДаты));
		
	Иначе
		
		ИнфоНадпись = "";
		
	КонецЕсли;
	
	ИнфоНадписьПериод = ИнфоНадпись;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТТНДатаТТН.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТТННомерТТН.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокТТН.Ссылка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокИзмененныхТТН;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СветлоЗеленый);
	
КонецПроцедуры

#КонецОбласти

#Область ОриентацияЭкрана

// ОриентацияЭкрана
&НаСервере
Процедура ПриИзмененииПараметровЭкранаСервер()
	
	ОбщегоНазначения.УстановитьОриентациюЭкрана();
	НастроитьФормуПоОриентацииЭкрана();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоОриентацииЭкрана()
	
КонецПроцедуры

#КонецОбласти
