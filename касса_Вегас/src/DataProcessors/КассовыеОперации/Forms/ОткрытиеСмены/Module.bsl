
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьФормуПоЗначениямНастроек();
	
	НастроитьПоляФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаблокироватьФорму();
	
	ОтобразитьСтраницуОткрытияСмены();
	ПодключитьОбработчикОжидания("Подключаемый_ОткрытьСмену", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	#Если МобильноеПриложениеКлиент Тогда
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	#КонецЕсли
	
	Если НЕ ДоступноЗакрытиеФормы Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ПодключаемоеОборудованиеКлиент.ОтключитьОборудование(ОборудованиеПечати);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПараметровЭкрана()
	
	// ОриентацияЭкрана
	ПриИзмененииПараметровЭкранаСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьЕщеРаз(Команда)
	
	ЗаблокироватьФорму();
	
	ОтобразитьСтраницуОткрытияСмены();
	ПодключитьОбработчикОжидания("Подключаемый_ОткрытьСмену", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ОткрытьСмену()
	
	ЕстьОшибки = Ложь;
	
	ВходныеПараметры = МенеджерОборудованияКлиентСервер.ПараметрыВыполненияОперации();
	ПродажиКлиент.ДобавитьПостоянныеПараметрыЧека(ВходныеПараметры);
	
	ВыходныеПараметры = Неопределено;
	
	ЛогированиеКлиентСервер.ЗаписатьСобытие("ОткрытьСмену");
	
	Если НЕ МенеджерОборудованияКлиент.ВыполнитьОткрытиеСменыНаФискальномУстройстве(
		УникальныйИдентификатор, ОборудованиеПечати, ВходныеПараметры, ВыходныеПараметры) Тогда
		
		ОтобразитьОшибкуОткрытияСмены(ВыходныеПараметры.ТекстОшибки);
		
		ЕстьОшибки = Истина;
		
		ЛогированиеКлиентСервер.ЗаписатьСобытие("ОткрытьСмену", "Ошибка - " + ВыходныеПараметры.ТекстОшибки);
		
	КонецЕсли;
	
	Если НЕ ЕстьОшибки Тогда
		
		ПродажиВызовСервера.ОткрытьДокументКассоваяСмена(ВыходныеПараметры.НомерСмены);
		Оповестить("ИзмененаКассоваяСмена");
		
		ЛогированиеКлиентСервер.ЗаписатьСобытие("ОткрытьСмену", "Открыта - " + ВыходныеПараметры.НомерСмены);
		
		ОтобразитьСтраницуУспешно();
		РазблокироватьФорму();
		ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьФорму", 1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьФорму()
	
	Закрыть();
	
КонецПроцедуры

#Область ОтображениеСтраниц

&НаКлиенте
Процедура ОтобразитьОшибкуОткрытияСмены(ОписаниеОшибки)
	
	ТекстОшибки = ОписаниеОшибки;
	
	РазблокироватьФорму();
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаОшибкаОткрытияСмены;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьСтраницуОткрытияСмены()
	
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаОткрытиеСмены;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьСтраницуУспешно()
	
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаСменаОткрыта;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура НастроитьФормуПоЗначениямНастроек()
	
	ОбщегоНазначения.УстановитьШрифт(ЭтаФорма);
	
	ОборудованиеПечати = ЗначениеНастроекВызовСервераПовтИсп.ОборудованиеПечати();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПоляФормы()
	
	ОбщегоНазначения.УстановитьЦветПолейОшибок(ЭтаФорма,
		"НадписьОшибкаОткрытияСмены"
	);
	
	ОбщегоНазначения.УстановитьЦветПолейУспешныхОпераций(ЭтаФорма,
		"НадписьСменаОткрыта"
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаблокироватьФорму()
	
	ДоступноЗакрытиеФормы = Ложь;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма, "Закрыть", "Доступность",
		Ложь);

КонецПроцедуры

&НаКлиенте
Процедура РазблокироватьФорму()
	
	ДоступноЗакрытиеФормы = Истина;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма, "Закрыть", "Доступность",
		Истина);

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

