
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЧека = Параметры.ПараметрыЧека;
	
	НастроитьФормуПоЗначениямНастроек();
	
	НастроитьПоляФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаблокироватьФорму();
	
	ОтобразитьСтраницуПечати();
	ПодключитьОбработчикОжидания("Подключаемый_Печать", 0.1, Истина);
	
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
	
	ОтобразитьСтраницуПечати();
	ПодключитьОбработчикОжидания("Подключаемый_Печать", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_Печать()
	
	ЕстьОшибки = Ложь;
	
	ШиринаСтроки = 32;
	
	Если ЗначениеЗаполнено(ОборудованиеПечати) Тогда
		
		ВыходныеПараметры = Неопределено;
		Если МенеджерОборудованияКлиент.ПолучитьШиринуСтрокиПечатающегоУстройства(ПодключаемоеОборудованиеКлиент.ИдентификаторКлиентаОборудования(),
				ОборудованиеПечати, Неопределено, ВыходныеПараметры) Тогда
				
				ШиринаСтроки = ВыходныеПараметры.ШиринаСтроки;
				
		КонецЕсли;
		
	КонецЕсли;
	
	ТекстПречека = МенеджерОборудованияКлиентСервер.СформироватьИнформационныйЧек(ПараметрыЧека, ШиринаСтроки);
	
	Если ЗначениеЗаполнено(ОборудованиеПечати) Тогда
		
		ВыходныеПараметры = Неопределено;
		ВходныеПараметры = Новый Структура("СтрокиТекста", ТекстПречека);
		
		Если НЕ МенеджерОборудованияКлиент.ВыполнитьПечатьТекста(ПодключаемоеОборудованиеКлиент.ИдентификаторКлиентаОборудования(),
			ОборудованиеПечати, ВходныеПараметры, ВыходныеПараметры) Тогда
			
				ОтобразитьОшибку(ВыходныеПараметры.ТекстОшибки);
				ЕстьОшибки = Истина;
				
		КонецЕсли;
		
		Если НЕ ЕстьОшибки Тогда
			
			ОтобразитьСтраницуУспешно();
			РазблокироватьФорму();
			ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьФорму", 1, Истина);
			
		КонецЕсли;

		
	Иначе
		
		ОтобразитьСтраницуПречека(ТекстПречека);
		
	КонецЕсли;
	
	РазблокироватьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьФорму()
	
	Закрыть();
	
КонецПроцедуры

#Область ОтображениеСтраниц

&НаКлиенте
Процедура ОтобразитьОшибку(ОписаниеОшибки)
	
	ТекстОшибки = ОписаниеОшибки;
	
	РазблокироватьФорму();
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаОшибка;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьСтраницуПечати()
	
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаПечать;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьСтраницуУспешно()
	
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаУспешно;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьСтраницуПречека(ТекстПречека)
	
	Пречек = ТекстПречека;
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаПречек;
	
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
		"НадписьОшибка"
	);
	
	ОбщегоНазначения.УстановитьЦветПолейУспешныхОпераций(ЭтаФорма,
		"НадписьУспешно"
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

