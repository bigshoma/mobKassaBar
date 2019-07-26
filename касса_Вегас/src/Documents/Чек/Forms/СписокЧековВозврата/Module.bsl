#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначения.ОформитьСуммовыеПоля(ЭтаФорма, "СписокЧековСуммаДокумента");
	
	НастроитьФормуПоЗначениямНастроек();
	
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораСписка(СписокЧеков, "ЧекПродажи", Параметры.ЧекПродажи);
	
	// ОриентацияЭкрана
	НастроитьФормуПоОриентацииЭкрана();
	
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
		
	КонецЕсли;
	
	Если ИмяСобытия = "ЗаписанЧек" Тогда
		
		Элементы.СписокЧеков.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьФормуПоЗначениямНастроек()
	
	ОбщегоНазначения.УстановитьШрифт(ЭтаФорма);
	
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

