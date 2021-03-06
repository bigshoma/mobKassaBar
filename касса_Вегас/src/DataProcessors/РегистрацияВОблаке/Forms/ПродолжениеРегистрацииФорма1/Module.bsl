
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьФормуПоЗначениямНастроек();
	
	ЗаполнитьОписание();
	
	НастроитьОтображениеПароля();
	
	Пароль = РегистрацияВОблакеВызовСервера.ПолучитьПарольПользователя();
	
	Если ЗначениеЗаполнено(Пароль) Тогда
		
		Элементы.СкрытьПароль.Видимость = Ложь;
		Элементы.ПоказатьПароль.Видимость = Ложь;
		
	КонецЕсли;
	
	ЗаводскойНомерККТ = РегистрацияВОблакеВызовСервера.ПолучитьЗаводскойНомерККТ();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыЗначенияНастроек" Тогда
		
		НастроитьФормуПоЗначениямНастроек();
		ЗаполнитьОписание();
		
	ИначеЕсли ИмяСобытия = "ЗакрытьМастер" Тогда
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПараметровЭкрана()
	
	// ОриентацияЭкрана
	ПриИзмененииПараметровЭкранаСервер();
	
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

#Область ОбработчикиСобытийЭлементов

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	Если НЕ ПроверитьЗаполнениеФормы() Тогда
		Возврат;
	КонецЕсли;
	
	РегистрацияВОблакеВызовСервера.СохранитьПарольПользователя(Пароль);
	
	РегистрацияВОблакеВызовСервера.СохранитьЗаводскойНомерККТ(ЗаводскойНомерККТ);
	
	Оповещение = Новый ОписаниеОповещения("УстановитьНастройкиЗавершение", ЭтотОбъект);
	
	РегистрацияВОблакеКлиент.УстановитьНастройки(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьПароль(Команда)
	
	ПарольОтображается = НЕ ПарольОтображается;
	НастроитьОтображениеПароля();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьМастер(Команда)
	
	РегистрацияВОблакеКлиент.ЗакрытьМастер();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьНастройкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если НЕ Результат.Успешно Тогда
		
		Сообщить(Результат.ТекстОшибки);
		Возврат;
		
	КонецЕсли;
	
	ОткрытьФорму("Обработка.РегистрацияВОблаке.Форма.ПродолжениеРегистрацииФорма2",,
		ЭтотОбъект,
		УникальныйИдентификатор
	);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОписание()
	
	АдресЭлектроннойПочты = РегистрацияВОблакеВызовСервера.ПолучитьEmailПользователя();
	
	Содержимое1 = НСтр("ru = 'Регистрация в сервисе 1С:Фреш завершена успешно!
		|
		|На электронную почту %1 отправлено письмо с Вашими регистрационными данными
		|
		|Введите полученный пароль для синхронизации с приложением 1С:Касса'"
	);
	
	Содержимое1 = ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыВСтроку(Содержимое1, АдресЭлектроннойПочты);
	
	МассивОписания = Новый Массив;
	МассивОписания.Добавить(Содержимое1);
	
	МассивОписания.Добавить(Символы.ПС);
	
	ОписаниеФорматированнаяСтрока = Новый ФорматированнаяСтрока(МассивОписания, ЗначениеНастроекПовтИсп.ШрифтПриложения());
	
	Элементы.Описание.Заголовок = ОписаниеФорматированнаяСтрока;
	
	
	ПодсказкаНомерККТ = НСтр("ru = 'Так же необходимо указать заводской номер ККТ'");
	
	МассивПодсказка = Новый Массив;
	МассивПодсказка.Добавить(ПодсказкаНомерККТ);
	
	ПодсказкаФорматированнаяСтрока = Новый ФорматированнаяСтрока(МассивПодсказка, ЗначениеНастроекПовтИсп.ШрифтПриложения());
	
	Элементы.ПодсказкаНомерККТ.Заголовок = ПодсказкаФорматированнаяСтрока;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоЗначениямНастроек()
	
	ОбщегоНазначения.УстановитьШрифт(ЭтотОбъект);
	ОбщегоНазначения.УстановитьЖирныйШрифтПолей(ЭтотОбъект, "Далее");
	
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеПароля()
	
	Если ПарольОтображается Тогда
		Элементы.СкрытьПароль.Видимость = Истина;
		Элементы.ПоказатьПароль.Видимость = Ложь;

		Элементы.Пароль.РежимПароля = Ложь;
		
	Иначе
		Элементы.СкрытьПароль.Видимость = Ложь;
		Элементы.ПоказатьПароль.Видимость = Истина;

		Элементы.Пароль.РежимПароля = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеФормы()
	
	Если НЕ ЗначениеЗаполнено(Пароль) Тогда
		
		ПомощникUIКлиент.СообщитьПолеНеЗаполнено(
			ЭтотОбъект,
			Элементы.Пароль,
			НСтр("ru = 'Пароль'")
		);
		
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ЗаводскойНомерККТ) Тогда
		
		ПомощникUIКлиент.СообщитьПолеНеЗаполнено(
			ЭтотОбъект,
			Элементы.ЗаводскойНомерККТ,
			НСтр("ru = 'Заводской номер ККТ'")
		);
		
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Пароль) Тогда
		НастроитьОтображениеПароля();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


