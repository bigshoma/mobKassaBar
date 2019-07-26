
Функция ПолучитьПредставлениеКоординат(Знач Широта, Знач Долгота) Экспорт
	
	Широта  = Строка(Широта);
	Долгота = Строка(Долгота);
	
	КоординатыСтрокой = НСтр("ru = 'N%Широта%, E%Долгота%'");
	
	Широта  = СтрЗаменить(Широта,  ",", ".");
	Долгота = СтрЗаменить(Долгота, ",", ".");
	
	КоординатыСтрокой = СтрЗаменить(КоординатыСтрокой, "%Широта%",  Широта);
	КоординатыСтрокой = СтрЗаменить(КоординатыСтрокой, "%Долгота%", Долгота);
	
	Возврат КоординатыСтрокой;
	
КонецФункции

Функция ПолучитьПредставлениеАдреса(АдресДоставкиГород = "", АдресДоставкиУлица = "", АдресДоставкиДом = "",
								АдресДоставкиКвартира = "", АдресДоставкиПодъезд = "", АдресДоставкиЭтаж = "") Экспорт
	
	АдресПредставление = "";
	
	Если НЕ ПустаяСтрока(АдресДоставкиГород) Тогда
		АдресПредставление = АдресДоставкиГород;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(АдресДоставкиУлица) Тогда
		
		АдресПредставление = АдресПредставление 
			+ ?(АдресПредставление = "", "", ", ")
			+ НСтр("ru = 'ул. '") + АдресДоставкиУлица;
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(АдресДоставкиДом) Тогда
		
		АдресПредставление = АдресПредставление
			+ ?(АдресПредставление = "", "", ", ")
			+ НСтр("ru = 'д. '") + АдресДоставкиДом;
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(АдресДоставкиКвартира) Тогда
		
		АдресПредставление = АдресПредставление
			+ ?(АдресПредставление = "", "", ", ")
			+ НСтр("ru = 'кв/офис. '") + АдресДоставкиКвартира;
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(АдресДоставкиПодъезд) Тогда
		
		АдресПредставление = АдресПредставление
			+ ?(АдресПредставление = "", "", ", ")
			+ НСтр("ru = 'под. '") + АдресДоставкиПодъезд;
		
	КонецЕсли;
		
	Если НЕ ПустаяСтрока(АдресДоставкиЭтаж) Тогда
		
		АдресПредставление = АдресПредставление
			+ ?(АдресПредставление = "", "", ", ")
			+ НСтр("ru = 'эт. '") + АдресДоставкиЭтаж;
		
	КонецЕсли;
	
	Возврат АдресПредставление;
КонецФункции
