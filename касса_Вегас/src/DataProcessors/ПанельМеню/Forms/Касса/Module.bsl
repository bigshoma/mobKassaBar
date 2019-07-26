
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СписокПолейСумм = "Наличные, Внесение, Выплата, Продажа, ПродажаНаличными, ПродажаПлатежнойКартой, Возврат, ВозвратНаличными, ВозвратПлатежнойКартой, Выручка";
	ОбщегоНазначения.ОформитьСуммовыеПоля(ЭтаФорма, СписокПолейСумм);
	ОбщегоНазначения.УстановитьЦветИтоговыхПолей(ЭтаФорма, СписокПолейСумм);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма,
		"ГруппаПродажаНаличными, ГруппаПродажаПлатежнойКартой, ГруппаВозвратНаличными, ГруппаВозвратПлатежнойКартой",
		"Видимость", Ложь);
	
	ОбщегоНазначения.ВосстановитьНастройкуПользователя(Перечисления.НастройкиПользователя.КассаПродажаРазвернуто, ПродажаРазвернуто);
	ОбщегоНазначения.ВосстановитьНастройкуПользователя(Перечисления.НастройкиПользователя.КассаВозвратРазвернуто, ВозвратРазвернуто);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма, "ГруппаПродажаНаличными, ГруппаПродажаПлатежнойКартой", "Видимость", ПродажаРазвернуто);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма, "ГруппаВозвратНаличными, ГруппаВозвратПлатежнойКартой", "Видимость", ВозвратРазвернуто);
	
	НастроитьФормуПоЗначениямНастроек();
	ОбновитьИнформациюПоКассовойСмене();
	ОбновитьОтчетПоКассе();
	
	ОбновитьОтображениеВыгрузкиДанных();
	
	// ОриентацияЭкрана
	НастроитьФормуПоОриентацииЭкрана();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияВызовСервера.СохранитьНастройкуПользователя("КассаПродажаРазвернуто", ПродажаРазвернуто);
	ОбщегоНазначенияВызовСервера.СохранитьНастройкуПользователя("КассаВозвратРазвернуто", ВозвратРазвернуто);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыЗначенияНастроек" Тогда
		
		ОбновитьИнформациюПоКассовойСмене();
		НастроитьФормуПоЗначениямНастроек();
		НастроитьДоступностьКомандПоСостояниюКассы();
		
	ИначеЕсли ИмяСобытия = "ИзмененаКассоваяСмена" Тогда
		
		ОбновитьИнформациюПоКассовойСмене();
		ОбновитьОтчетПоКассе();
		ОбновитьОтображениеВыгрузкиДанных();
		
	ИначеЕсли ИмяСобытия = "КассоваяОперация" Тогда
		
		ОбновитьОтчетПоКассе();
	
	ИначеЕсли ИмяСобытия = "ВыполненОбмен" Тогда
		
		ОбновитьОтображениеВыгрузкиДанных();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПараметровЭкрана()
	
	// ОриентацияЭкрана
	ПриИзмененииПараметровЭкранаСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура ПродажаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПродажаРазвернуто = НЕ ПродажаРазвернуто;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма, "ГруппаПродажаНаличными, ГруппаПродажаПлатежнойКартой", "Видимость", ПродажаРазвернуто);
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвратНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВозвратРазвернуто = НЕ ВозвратРазвернуто;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма, "ГруппаВозвратНаличными, ГруппаВозвратПлатежнойКартой", "Видимость", ВозвратРазвернуто);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВнестиНаличные(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидДвижения", "Внесение");
	
	ОткрытьФорму("Документ.ВнесениеИзъятиеНаличных.Форма.ФормаДокумента", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзъятьНаличные(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидДвижения", "Изъятие");
	
	ОткрытьФорму("Документ.ВнесениеИзъятиеНаличных.Форма.ФормаДокумента", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетБезГашения(Команда)
	
	ПродажиКлиент.ОтчетБезГашения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьСмену(Команда)
	
	ПродажиКлиент.ЗакрытьСмену(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СверитьИтогиПоПлатежнойСистеме(Команда)
	
	ПродажиКлиент.СверитьИОтобразитьИтогиПоПлатежнойСистеме(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьДанные(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Выгрузка");
	ОткрытьФорму("Обработка.Сервис.Форма.Синхронизация", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСмену(Команда)
	
	ПродажиКлиент.ОткрытьСмену(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетОТекущемСостоянииРасчетов(Команда)
	
	КассовыеОперацииКлиент.ВыполнитьОтчетОТекущемСостоянииРасчетов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСостояниеККТ(Команда)
	
	КассовыеОперацииКлиент.ПоказатьСостояниеККТ(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьОтображениеВыгрузкиДанных()
	
	Если ДоступнаВыгрузкаДанных Тогда
		
		КоличествоОтчетов = Документы.ОтчетОРозничныхПродажах.ОтчетыОПродажахКВыгрузке().Количество();
		
		Элементы.ВыгрузитьДанные.Заголовок = СтрЗаменить(
			НСтр("ru = 'Выгрузить данные (%КоличествоОтчетов%)'"),
			"%КоличествоОтчетов%",
			КоличествоОтчетов
		);
		
		Элементы.ВыгрузитьДанные.Доступность = НЕ КоличествоОтчетов = 0;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоЗначениямНастроек()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма, "ОтчетБезГашения", "Видимость",
		ЗначениеЗаполнено(ЗначениеНастроекВызовСервераПовтИсп.ОборудованиеПечати()));
	
	ОбщегоНазначения.УстановитьШрифт(ЭтаФорма);
	
	ИспользоватьОплатуПлатежнымиКартами = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ИспользоватьОплатуПлатежнымиКартами");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма, "Продажа, Возврат", "Гиперссылка",
		ИспользоватьОплатуПлатежнымиКартами);
	
	Если НЕ ИспользоватьОплатуПлатежнымиКартами Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма,
			"ГруппаПродажаНаличными, ГруппаПродажаПлатежнойКартой, ГруппаВозвратНаличными, ГруппаВозвратПлатежнойКартой",
			"Видимость",
			Ложь
		);
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма,
		"ГруппаПлатежнаяСистема",
		"Видимость",
		ЗначениеНастроекВызовСервераПовтИсп.ИспользуетсяПлатежнаяСистема());
		
	ДоступнаВыгрузкаДанных = ЗначениеНастроекВызовСервераПовтИсп.УстановленРежимСинхронизации()
		И НЕ ЗначениеНастроекВызовСервераПовтИсп.ЭтоАвтономныйРежим();
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма, "ВыгрузитьДанные", "Видимость",
		ДоступнаВыгрузкаДанных);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма, "ПоказатьСостояниеККТ", "Видимость",
		ЗначениеНастроекВызовСервераПовтИсп.ИспользуетсяККТ());

КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюПоКассовойСмене()
	
	Продажи.ОбновитьИнформациюПоКассовойСмене(ЭтаФорма, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтчетПоКассе()
	
	ОтчетПоКассе = Продажи.ОтчетПоКассе(КассоваяСмена);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ОтчетПоКассе, "Наличные, Внесение, Выплата, Продажа, ПродажаНаличными, ПродажаПлатежнойКартой, Возврат, ВозвратНаличными, ВозвратПлатежнойКартой, Выручка");
	
	НастроитьДоступностьКомандПоСостояниюКассы();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьДоступностьКомандПоСостояниюКассы()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма, "ВнестиНаличные", "Доступность", НЕ КассоваяСменаПросрочена);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма, "ИзъятьНаличные", "Доступность",
		Наличные > 0 И НЕ КассоваяСменаПросрочена
		);
		
	Если ЗначениеНастроекВызовСервераПовтИсп.ИспользуетсяККТ() Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма, "ОтчетОТекущемСостоянииРасчетов", "Видимость",
			Истина
		);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма, "ОтчетОТекущемСостоянииРасчетов", "Доступность",
			НЕ КассоваяСменаОткрыта
		);
		
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма, "ОтчетОТекущемСостоянииРасчетов", "Видимость",
			Ложь
		);
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементовФормы(ЭтаФорма, "ЗакрытьСмену, ОтчетБезГашения", "Доступность", ЗначениеЗаполнено(КассоваяСмена));
	
	Если КассоваяСменаПросрочена Тогда
		ОбщегоНазначения.УстановитьЦветПолейОшибок(ЭтаФорма, "ЗакрытьСмену");
	Иначе
		ОбщегоНазначения.СброситьЦветПолей(ЭтаФорма, "ЗакрытьСмену");
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
