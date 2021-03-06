
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьФормуПоЗначениямНастроек();
	
	АдминистративныйРежим = ПараметрыСеанса.АдминистративныйРежим;
	Если НЕ АдминистративныйРежим Тогда
		Элементы.Готово.Видимость = Ложь;
	КонецЕсли;
	
	УстановитьВидимостьКнопокФормы();
	
	// ОриентацияЭкрана
	НастроитьФормуПоОриентацииЭкрана();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПараметровЭкрана()
	
	// ОриентацияЭкрана
	ПриИзмененииПараметровЭкранаСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УдалитьВидОплаты(Команда)
	
	Объект.ПометкаУдаления = Истина;
	
	Записать();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометкуУдаления(Команда)
	
	Объект.ПометкаУдаления = Ложь;
	
	Записать();
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьФормуПоЗначениямНастроек()
	
	ОбщегоНазначения.УстановитьШрифт(ЭтотОбъект);
	
	ОбщегоНазначения.НастроитьКомандуГотово(ЭтотОбъект, , , 2);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКнопокФормы()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма, "УдалитьВидОплаты", "Видимость",
		АдминистративныйРежим И ЗначениеЗаполнено(Объект.Ссылка) И НЕ Объект.ПометкаУдаления);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма, "СнятьПометкуУдаления", "Видимость",
		АдминистративныйРежим И ЗначениеЗаполнено(Объект.Ссылка) И Объект.ПометкаУдаления);
	
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
