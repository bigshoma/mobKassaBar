
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	РежимПодбора = Параметры.РежимПодбора;
	
	ОбщегоНазначения.ОформитьСуммовыеПоля(ЭтаФорма, "КорзинаЦена, КорзинаСумма, Сумма");
	ОбщегоНазначения.УстановитьЦветИтоговыхПолей(ЭтаФорма, "Сумма");
	
	НастроитьФормуПоЗначениямНастроек();
	
	// ОриентацияЭкрана
	НастроитьФормуПоОриентацииЭкрана();
	
	ТаблицаКорзина = ПолучитьИзВременногоХранилища(Параметры.АдресВоВременномХранилище);
	
	Для Каждого СтрокаТаблица Из ТаблицаКорзина Цикл
		
		НоваяСтрока = Корзина.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблица, "Номенклатура, Цена, Количество, Сумма");
	КонецЦикла;
	
	
	ФорматСуммы = ОбщегоНазначенияПовтИсп.ФорматСуммовыхПолей();
	ФорматКоличества = ЗначениеНастроекПовтИсп.ФорматКоличественныхПолей();
	
	Для Каждого СтрокаТЧ Из Корзина Цикл
		ОбновитьЗаписьПоСтроке(СтрокаТЧ);
	КонецЦикла;
	
	Сумма = Корзина.Итог("Сумма");
	
	УстановитьВидимостьПоРежимуПодбора();
	
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
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьПоРежимуПодбора()
	
	Если РежимПодбора = "ПодборБезСуммы" Тогда
		
		СписокВидимость = "Сумма";
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма, СписокВидимость,
			"Видимость", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоЗначениямНастроек()
	
	ОбщегоНазначения.УстановитьШрифт(ЭтаФорма);
	ОбщегоНазначения.УстановитьВысотуПоляНаименованиеТовара(ЭтаФорма, "КорзинаНоменклатура");
	
	ОбщегоНазначения.НастроитьКомандуГотово(ЭтотОбъект, "ГруппаЗакрытьФорму", "ЗакрытьФорму", 2, Ложь, Ложь);
	
	ОбщегоНазначения.УстановитьЖирныйШрифтПолей(ЭтотОбъект, "Сумма");
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаписьПоСтроке(Знач Строка)
	
	СтрокаТЧ = Строка;
	
	Если РежимПодбора = "ПодборБезСуммы" Тогда
		ЗаписьПоСтроке = НСтр("ru = '%Количество%%ЕдИзм%'");
	Иначе
		ЗаписьПоСтроке = НСтр("ru = '%Количество%%ЕдИзм% Х %Цена% = %Сумма%'");
	КонецЕсли;
	
	ЗаписьПоСтроке = СтрЗаменить(ЗаписьПоСтроке, "%Количество%", Формат(СтрокаТЧ.Количество, ФорматКоличества));
	ЗаписьПоСтроке = СтрЗаменить(ЗаписьПоСтроке, "%ЕдИзм%",      Строка(СтрокаТЧ.Номенклатура.ЕдиницаИзмерения));
	ЗаписьПоСтроке = СтрЗаменить(ЗаписьПоСтроке, "%Цена%",       Формат(СтрокаТЧ.Цена, ФорматСуммы));
	ЗаписьПоСтроке = СтрЗаменить(ЗаписьПоСтроке, "%Сумма%",      Формат(СтрокаТЧ.Сумма, ФорматСуммы));
	
	СтрокаТЧ.ЗаписьПоСтроке = ЗаписьПоСтроке;
	
КонецПроцедуры

#КонецОбласти

#Область ОриентацияЭкрана

&НаСервере
Процедура ПриИзмененииПараметровЭкранаСервер()
	
	ОбщегоНазначения.УстановитьОриентациюЭкрана();
	НастроитьФормуПоОриентацииЭкрана();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоОриентацииЭкрана()
	//
КонецПроцедуры

#КонецОбласти
