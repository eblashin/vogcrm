
// +++ VOG Кулаков П.Л. 12.08.2020 CRM-543
Процедура ПередЗаписью(Отказ, Замещение)
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		Если Запись.СтадияЖизненногоЦикла = Перечисления.СтадииЖизненногоЦиклаОбои.Заказной Тогда
			Запись.СтатусПродажПоХолдингу = Перечисления.СтатусыABC.ПустаяСсылка();
			Запись.СтатусПродажПоБренду = Перечисления.СтатусыABC.ПустаяСсылка();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // --- VOG Кулаков П.Л.
