
#Область ПрограммныйИнтерфейс

Функция ПолучитьКоординатыПоМестоположению(Местоположение) Экспорт
	
	Координаты = Новый ГеографическиеКоординаты(
			Местоположение.Координаты.Широта,
			Местоположение.Координаты.Долгота,
			Местоположение.Координаты.Высота
		);
		
	Возврат Координаты;
	
КонецФункции

Функция ОбновитьМестоположение() Экспорт
	
	#Если МобильноеПриложениеКлиент Тогда
		
		ПомощникUIКлиент.ПоказатьСообщение(НСтр("ru = 'Обновление местоположения'"));
		
		Провайдеры = СредстваГеопозиционирования.ПолучитьПровайдеров();
		
		Провайдер = СредстваГеопозиционирования.ПолучитьСамогоЭнергоЭкономичногоПровайдера();
		
		Местоположение = СредстваГеопозиционирования.ПолучитьПоследнееМестоположение(Провайдер.Имя);
		
		Таймаут = 300; // 5 минут
		
		ПолученОтветПровайдера = СредстваГеопозиционирования.ОбновитьМестоположение(Провайдер.Имя, Таймаут);
		
		Если ПолученОтветПровайдера Тогда
			Местоположение = СредстваГеопозиционирования.ПолучитьПоследнееМестоположение(Провайдер.Имя);
			
			Если НЕ Провайдер.Имя = ОбщегоНазначенияВызовСервера.ПолучитьПараметрСеанса("ИмяПровайдераГеолокации") Тогда
				
				ОбщегоНазначенияВызовСервера.УстановитьПараметрСеанса("ИмяПровайдераГеолокации", Провайдер.Имя);
			КонецЕсли;
			
			Оповестить("ОбновленоМестоположение");
		КонецЕсли;
			
		Возврат Местоположение;
		
	#Иначе
		
		ТекстИсключения = НСтр("ru = 'Операция доступна только из мобильного приложения'");
		ВызватьИсключение ТекстИсключения;
		
	#КонецЕсли
	
КонецФункции

Функция ПолучитьМестоположение() Экспорт
	
	#Если МобильноеПриложениеКлиент Тогда
		
		Местоположение = Неопределено;
		
		ИмяПровайдераГеолокации = ОбщегоНазначенияВызовСервера.ПолучитьПараметрСеанса("ИмяПровайдераГеолокации");
		
		Если ПустаяСтрока(ИмяПровайдераГеолокации) Тогда
			
			Местоположение = ОбновитьМестоположение();
			
			Возврат Местоположение;
		КонецЕсли;
		
		
		Местоположение = СредстваГеопозиционирования.ПолучитьПоследнееМестоположение(ИмяПровайдераГеолокации);
		
		ЧастотаОбновленияКоординат = ЗначениеНастроекВызовСервераПовтИсп.ЧастотаОбновленияКоординат();
		
		Если ЧастотаОбновленияКоординат = 0 Тогда // один раз, при запуске
			
			Если Местоположение = Неопределено Тогда
				
				Местоположение = ОбновитьМестоположение();
			КонецЕсли;
			
		Иначе
			
			Если Местоположение = Неопределено Тогда
				
				Местоположение = ОбновитьМестоположение();
				
			Иначе
				
				ДатаОпределения = Местоположение.Дата;
				
				Если ОбщегоНазначенияКлиентСервер.ПолучитьТекущуюДату() - ДатаОпределения > ЧастотаОбновленияКоординат Тогда
					
					Местоположение = ОбновитьМестоположение();
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Возврат Местоположение;
		
	#Иначе
		
		ТекстИсключения = НСтр("ru = 'Операция доступна только из мобильного приложения'");
		ВызватьИсключение ТекстИсключения;
		
	#КонецЕсли
	
КонецФункции

Функция ПолучитьПредставлениеМестоположения(Координаты = Неопределено, Знач Широта = 0, Знач Долгота = 0) Экспорт
	
	Если Координаты = Неопределено Тогда
		Координаты = Новый ГеографическиеКоординаты(Широта, Долгота);
	КонецЕсли;
	
	ДанныеАдреса = Неопределено;
	#Если МобильноеПриложениеКлиент Тогда
		ДанныеАдреса = ПолучитьАдресПоМестоположению(Координаты);
	#КонецЕсли
	
	Если ДанныеАдреса = Неопределено Тогда
		ПредставлениеМестоположения = ПолучитьПредставлениеКоординат(Координаты);
	Иначе
		ПредставлениеМестоположения = ПолучитьПредставлениеАдреса(ДанныеАдреса);
	КонецЕсли;
	
	Возврат ПредставлениеМестоположения;
	
КонецФункции

Функция ПолучитьПредставлениеКоординатМестоположения(Координаты = Неопределено, Знач Широта = 0, Знач Долгота = 0) Экспорт
	
	Если Координаты = Неопределено Тогда
		Координаты = Новый ГеографическиеКоординаты(Широта, Долгота);
	КонецЕсли;
	
	ПредставлениеМестоположения = ПолучитьПредставлениеКоординат(Координаты);
	
	Возврат ПредставлениеМестоположения;
	
КонецФункции

Функция ПолучитьПредставлениеАдресаМестоположения(Координаты = Неопределено, Знач Широта = 0, Знач Долгота = 0) Экспорт
	
	Если Координаты = Неопределено Тогда
		Координаты = Новый ГеографическиеКоординаты(Широта, Долгота);
	КонецЕсли;
	
	ДанныеАдреса = Неопределено;
	#Если МобильноеПриложениеКлиент Тогда
		ДанныеАдреса = ПолучитьАдресПоМестоположению(Координаты);
	#КонецЕсли
	
	ПредставлениеАдресаМестоположения = "";
	
	Если НЕ ДанныеАдреса = Неопределено Тогда
		ПредставлениеАдресаМестоположения = ПолучитьПредставлениеАдреса(ДанныеАдреса);
	КонецЕсли;
	
	Возврат ПредставлениеАдресаМестоположения;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПредставлениеКоординат(Координаты)
	
	Возврат ГеолокацияКлиентСервер.ПолучитьПредставлениеКоординат(Координаты.Широта, Координаты.Долгота);
	
КонецФункции

Функция ПолучитьПредставлениеАдреса(ДанныеАдреса)
	
	АдресСтрокой = НСтр("ru = '%Улица%, %Дом%, %Город%'");
	
	АдресСтрокой = СтрЗаменить(АдресСтрокой, "%Улица%", ДанныеАдреса.СтрокаАдресаОсновная);
	АдресСтрокой = СтрЗаменить(АдресСтрокой, "%Дом%",   ДанныеАдреса.СтрокаАдресаДополнительная);
	АдресСтрокой = СтрЗаменить(АдресСтрокой, "%Город%", ДанныеАдреса.Город);
	
	Возврат АдресСтрокой;
	
КонецФункции

#КонецОбласти
