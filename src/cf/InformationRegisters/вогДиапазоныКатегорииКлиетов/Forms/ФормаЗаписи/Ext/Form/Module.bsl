
&НаКлиенте
Процедура НижняяГраницаПриИзменении(Элемент)
	
	Запись.ПредставлениеДиапазона = ?(ЗначениеЗаполнено(Запись.НижняяГраница),"от " + Запись.НижняяГраница,"") + ?(ЗначениеЗаполнено(Запись.ВерхняяГраница)," до " + Запись.ВерхняяГраница,"") + " руб.";
	
КонецПроцедуры

&НаКлиенте
Процедура ВерхняяГраницаПриИзменении(Элемент)
	
	Запись.ПредставлениеДиапазона = ?(ЗначениеЗаполнено(Запись.НижняяГраница),"от " + Запись.НижняяГраница,"") + ?(ЗначениеЗаполнено(Запись.ВерхняяГраница)," до " + Запись.ВерхняяГраница,"") + " руб.";
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КатегорияКлиента = ПланыВидовХарактеристик.CRM_Классификаторы.ПолучитьСсылку(Новый УникальныйИдентификатор("6dc27b50-aae3-11ea-8c71-005056bc3fe8"));
	НовыеПараметрыВыбора = Новый ПараметрВыбора("Отбор.Владелец",КатегорияКлиента);
	Массив = Новый Массив;
	Массив.Добавить(НовыеПараметрыВыбора);
	МассивПараметровВыбора = Новый ФиксированныйМассив(Массив);
	Элементы.Категория.ПараметрыВыбора = МассивПараметровВыбора;
	
КонецПроцедуры
