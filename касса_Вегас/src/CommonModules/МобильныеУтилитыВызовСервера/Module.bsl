
Процедура СоздатьZIP(СписокФайлов, ПолныйПутьZipФайла) Экспорт
	
	#Если НЕ МобильноеПриложениеСервер Тогда
		ЗаписьZip = Новый ЗаписьZipФайла(ПолныйПутьZipФайла);
		
		Для Каждого ИмяФайла Из СписокФайлов Цикл
			ЗаписьZip.Добавить(ИмяФайла);
		КонецЦикла;
		
		ЗаписьZip.Записать();
	#КонецЕсли
	
КонецПроцедуры