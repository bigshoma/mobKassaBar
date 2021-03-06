
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьФормуПоЗначениямНастроек();
	
	НастроитьФормуПоАдминистративномуРежиму();
	
	// ОриентацияЭкрана
	НастроитьФормуПоОриентацииЭкрана();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПараметровЭкрана()
	
	// ОриентацияЭкрана
	ПриИзмененииПараметровЭкранаСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Включить(Команда)
	
	Если НЕ ПроверитьЗаполнениеФормы() Тогда
		Возврат;
	КонецЕсли;
	
	Если Пароль = УстановленныйПароль Тогда
		
		ИзменитьАдминистративныйРежим(Истина);
		
	Иначе
		ТекстСообщения = НСтр("ru = 'Введен неверный пароль'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Оповестить("ИзмененАдминистративныйРежим");
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Выключить(Команда)
	
	ИзменитьАдминистративныйРежим(Ложь);
	
	Оповестить("ИзмененАдминистративныйРежим");
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПароль(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ОповещениеУстановкаПароля", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.УстановкаПароля",,ЭтаФорма,,,,Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьПароль(Команда)
	
	ПарольОтображается = НЕ ПарольОтображается;
	НастроитьОтображениеПароля();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПроверитьЗаполнениеФормы()
	
	Если ЗначениеЗаполнено(УстановленныйПароль) И НЕ ЗначениеЗаполнено(Пароль) Тогда
		
		ПомощникUIКлиент.СообщитьПолеНеЗаполнено(ЭтотОбъект, Элементы.Пароль, НСтр("ru = 'Пароль'"));
		
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура НастроитьФормуПоЗначениямНастроек()
	
	ОбщегоНазначения.УстановитьШрифт(ЭтаФорма);
	
	ОбщегоНазначения.НастроитьКомандуГотово(ЭтотОбъект, "ГруппаВключить", "Включить", 2, Ложь);
	ОбщегоНазначения.НастроитьКомандуГотово(ЭтотОбъект, "ГруппаВыключить", "Выключить", 2, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоАдминистративномуРежиму()
	
	АдминистративныйРежим = ПараметрыСеанса.АдминистративныйРежим;
	
	Элементы.Включить.Видимость                   = НЕ АдминистративныйРежим;
	Элементы.Выключить.Видимость                   = АдминистративныйРежим;
	
	ОтобразитьСкрытьВводПароля();
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьАдминистративныйРежим(Флаг)
	
	ОбщегоНазначения.ИзменитьАдминистративныйРежим(Флаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеУстановкаПароля(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат = "УстановленПароль" Тогда
		ОтобразитьСкрытьВводПароля();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьСкрытьВводПароля()
	
	ПарольАдминистративногоРежима = Константы.ПарольАдминистративногоРежима.Получить();
	УстановленныйПароль = ПарольАдминистративногоРежима;
	
	Если ЗначениеЗаполнено(ПарольАдминистративногоРежима) Тогда
		Элементы.УстановитьПароль.Заголовок = НСтр("ru = 'Изменить пароль'");
	Иначе
		Элементы.УстановитьПароль.Заголовок = НСтр("ru = 'Установить пароль'");
	КонецЕсли;
	
	Элементы.ГруппаПароль.Видимость = ЗначениеЗаполнено(УстановленныйПароль) И НЕ АдминистративныйРежим;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтображениеПароля()
	
	Если ПарольОтображается Тогда
		
		Элементы.СтраницыПароль.ТекущаяСтраница = Элементы.СтраницаПарольГлазПеречеркнутый;
		
	Иначе
		
		Элементы.СтраницыПароль.ТекущаяСтраница = Элементы.СтраницаПарольГлаз;
		
	КонецЕсли;
	
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

