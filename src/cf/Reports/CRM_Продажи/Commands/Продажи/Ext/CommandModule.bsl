
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ЗначениеЗаполнено(ПараметрКоманды) Тогда
		ПараметрыФормы = Новый Структура("Отбор,КлючВарианта, СформироватьПриОткрытии",Новый Структура("Клиент", ПараметрКоманды),"ПоКлиентам", Истина);
		ОткрытьФорму("Отчет.CRM_Продажи.Форма",ПараметрыФормы,,,ПараметрыВыполненияКоманды.Окно);
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Клиент не связан с Партнером базы CRM!'")); 
	КонецЕсли;

КонецПроцедуры
