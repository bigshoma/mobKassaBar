
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Заголовок = Параметры.ФИО;
	ТекущийКодДоступа = Параметры.УстановленныйКодДоступа;
	
	Если Параметры.Свойство("ЗапретИзмененияПользователя") И Параметры.ЗапретИзмененияПользователя Тогда
		
		ЗапретИзмененияПользователя = Истина;
		
		Элементы.ЗакрытьФорму.Видимость = Ложь;
		
		Элементы.КнопкаЗавершениеРаботыПустышка.Видимость = Ложь;
		Элементы.КнопкаЗавершениеРаботы.Видимость = Истина;
		
	Иначе
		Элементы.КнопкаЗавершениеРаботыПустышка.Видимость = Истина;
		Элементы.КнопкаЗавершениеРаботы.Видимость = Ложь;
	КонецЕсли;
	
	РежимФормы = Параметры.РежимФормы;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗапретИзмененияПользователя И НЕ ПлановоеЗакрытиеФормы Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОпределитьТекущуюОперацию();
	
	Подключаемый_НастроитьФормуПоТекущейОперации();
	
	УстановитьКодДоступаСкрытый();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура Кнопка1Нажатие(Элемент)
	
	ДобавитьККодуДоступа("1");
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка2Нажатие(Элемент)
	
	ДобавитьККодуДоступа("2");
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка3Нажатие(Элемент)
	
	ДобавитьККодуДоступа("3");
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка4Нажатие(Элемент)
	
	ДобавитьККодуДоступа("4");
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка5Нажатие(Элемент)
	
	ДобавитьККодуДоступа("5");
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка6Нажатие(Элемент)
	
	ДобавитьККодуДоступа("6");
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка7Нажатие(Элемент)
	
	ДобавитьККодуДоступа("7");
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка8Нажатие(Элемент)
	
	ДобавитьККодуДоступа("8");
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка9Нажатие(Элемент)
	
	ДобавитьККодуДоступа("9");
	
КонецПроцедуры

&НаКлиенте
Процедура Кнопка0Нажатие(Элемент)
	ДобавитьККодуДоступа("0");
КонецПроцедуры

&НаКлиенте
Процедура КнопкаУдалитьНажатие(Элемент)
	
	ДлинаВводимыйКодДоступа = СтрДлина(ВводимыйКодДоступа);
	ВводимыйКодДоступа = Лев(ВводимыйКодДоступа, ДлинаВводимыйКодДоступа - 1);
	ПроверитьКодДоступа();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьККодуДоступа(ВведеннаяЦифра)
	
	Если СтрДлина(ВводимыйКодДоступа) < 4 Тогда
		ВводимыйКодДоступа = ВводимыйКодДоступа + ВведеннаяЦифра;
		ПроверитьКодДоступа();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаЗавершениеРаботыНажатие(Элемент)
	
	ЗавершитьРаботуСистемы(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьКодДоступаСкрытый()
	
	Если СтрДлина(ВводимыйКодДоступа) = 0 Тогда
		
		Элементы.СтраницыТочки.ТекущаяСтраница = Элементы.СтраницаТочки0;
		
	ИначеЕсли СтрДлина(ВводимыйКодДоступа) = 1 Тогда
		
		Элементы.СтраницыТочки.ТекущаяСтраница = Элементы.СтраницаТочки1;
		
	ИначеЕсли СтрДлина(ВводимыйКодДоступа) = 2 Тогда
		
		Элементы.СтраницыТочки.ТекущаяСтраница = Элементы.СтраницаТочки2;
		
	ИначеЕсли СтрДлина(ВводимыйКодДоступа) = 3 Тогда
		
		Элементы.СтраницыТочки.ТекущаяСтраница = Элементы.СтраницаТочки3;
		
	ИначеЕсли СтрДлина(ВводимыйКодДоступа) = 4 Тогда
		
		Элементы.СтраницыТочки.ТекущаяСтраница = Элементы.СтраницаТочки4;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьТекущуюОперацию()
	
	Если РежимФормы = "ИзменитьКод" И ТекущийКодДоступа = "" Тогда
		
		ТекущаяОперация = "УстановкаНовогоКодаДоступа";
		
	ИначеЕсли РежимФормы = "ИзменитьКод" И НЕ ТекущийКодДоступа = "" Тогда
		
		ТекущаяОперация = "ВводСтарогоКодаДоступа";
		
	ИначеЕсли РежимФормы = "ВыключитьКод" ИЛИ РежимФормы = "ВвестиКод" Тогда
		
		ТекущаяОперация = "ВводКодаДоступа";
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НастроитьФормуПоТекущейОперации()
	
	ВводимыйКодДоступа = "";
	
	Если ТекущаяОперация = "УстановкаНовогоКодаДоступа" ИЛИ ТекущаяОперация = "ВводКодаДоступа" Тогда
		
		Элементы.СтраницыЗаголовок.ТекущаяСтраница = Элементы.СтраницаКодДоступа;
		
	ИначеЕсли ТекущаяОперация = "ПодтверждениеНовогоКодаДоступа" Тогда
		
		Элементы.СтраницыЗаголовок.ТекущаяСтраница = Элементы.СтраницаКодДоступаПодтверждение;
		
	ИначеЕсли ТекущаяОперация = "ВводСтарогоКодаДоступа" Тогда
		
		Элементы.СтраницыЗаголовок.ТекущаяСтраница = Элементы.СтраницаСтарыйКод;
		
	ИначеЕсли ТекущаяОперация = "ВводНовогоКодаДоступа" Тогда
		
		Элементы.СтраницыЗаголовок.ТекущаяСтраница = Элементы.СтраницаНовыйКодДоступа;
		
	КонецЕсли;
	
	УстановитьКодДоступаСкрытый();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьКодДоступа()
	
	УстановитьКодДоступаСкрытый();
	
	Если НЕ ТекстОшибки = "" Тогда
		ТекстОшибки = "";
		Элементы.ДекорацияОшибка.Заголовок = ТекстОшибки;
	КонецЕсли;
	
	Если СтрДлина(ВводимыйКодДоступа) = 4 Тогда
		
		Если ТекущаяОперация = "ВводКодаДоступа" Тогда
			
			Если ТекущийКодДоступа = ВводимыйКодДоступа Тогда
				
				ЗакрытьФорму();
				
			Иначе
				
				ТекстОшибки = НСтр("ru = 'Неверный код. Повторите попытку.'");
				
			КонецЕсли;
			
		ИначеЕсли ТекущаяОперация = "УстановкаНовогоКодаДоступа" ИЛИ ТекущаяОперация = "ВводНовогоКодаДоступа" Тогда
			
			КодДоступаНовый = ВводимыйКодДоступа;
			
			ТекущаяОперация = "ПодтверждениеНовогоКодаДоступа";
			
			НастроитьФормуПоТекущейОперации();
			
		ИначеЕсли ТекущаяОперация = "ПодтверждениеНовогоКодаДоступа" Тогда
			
			КодДоступаПодтверждение = ВводимыйКодДоступа;
			
			Если КодДоступаНовый = КодДоступаПодтверждение Тогда
				
				ЗакрытьФорму();
				
			Иначе
				
				Если ЗначениеЗаполнено(ТекущийКодДоступа) Тогда
					ТекущаяОперация = "ВводНовогоКодаДоступа";
				Иначе
					ТекущаяОперация = "УстановкаНовогоКодаДоступа";
				КонецЕсли;
				
				ТекстОшибки = НСтр("ru = 'Коды доступа не совпали. Повторите попытку.'");
				
				НастроитьФормуПоТекущейОперации();
				
			КонецЕсли;
			
		ИначеЕсли ТекущаяОперация = "ВводСтарогоКодаДоступа" Тогда
			
			СтарыйКодДоступа = ВводимыйКодДоступа;
			
			Если СтарыйКодДоступа = ТекущийКодДоступа Тогда
				
				ТекущаяОперация = "ВводНовогоКодаДоступа";
				НастроитьФормуПоТекущейОперации();
				
			Иначе
				
				ТекстОшибки = НСтр("ru = 'Неверный код. Повторите попытку.'");
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если НЕ ТекстОшибки = "" Тогда
			Элементы.ДекорацияОшибка.Заголовок = ТекстОшибки;
			ВводимыйКодДоступа = "";
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьФормуПоТекущейОперации()
	
	ПодключитьОбработчикОжидания("Подключаемый_НастроитьФормуПоТекущейОперации", 0.5, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму()
	
	ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьФорму", 0.5, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьФорму()
	
	ПлановоеЗакрытиеФормы = Истина;
	
	Если РежимФормы = "ИзменитьКод" Тогда
		
		Закрыть(КодДоступаНовый);
		
	Иначе
		Закрыть(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти