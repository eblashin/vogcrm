// В данный модуль вынесены методы подсистемы CRM, вызываемые из модулей типовых объектов. 
// Выносить можно только те методы, которые не вызывают стандартные методы типового модуля или обработчики форм. 
// Т.е. вызывают только те методы, что тоже вынесены из типового или не содержат таких вызовов.

// Для каждого объекта необходимо задать свою #Область с именем объекта и модуля, как он называется в метаданных.

#Область Обработка_УниверсальныйОбменДаннымиXML_УправляемаяФорма

Процедура CRM_УстановитьСвойстваЭлементовФормы(Форма) Экспорт
	
	Форма.Элементы.Выгрузка.Видимость		= (Форма.CRM_ТолькоВыгрузка И НЕ Форма.CRM_ТолькоЗагрузка)ИЛИ (НЕ Форма.CRM_ТолькоВыгрузка И НЕ Форма.CRM_ТолькоЗагрузка);
	Форма.Элементы.Загрузка.Видимость		= (НЕ Форма.CRM_ТолькоВыгрузка И Форма.CRM_ТолькоЗагрузка)ИЛИ (НЕ Форма.CRM_ТолькоВыгрузка И НЕ Форма.CRM_ТолькоЗагрузка);
	Форма.Элементы.РежимВыгрузки.Видимость	= (Форма.CRM_ТолькоВыгрузка И (Форма.CRM_ИмяТекущейКонфигурации = "CRM" И Форма.CRM_ВерсияТекущейКонфигурации = "3"));
	
	Если Форма.CRM_ТолькоВыгрузка ИЛИ Форма.CRM_ТолькоЗагрузка Тогда
		//Форма.Элементы.ГлавнаяПанельФормы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		Форма.Заголовок = ?(Форма.CRM_ТолькоВыгрузка,НСтр("ru = 'Выгрузка счетов на оплату'"),НСтр("ru = 'Загрузка данных из файла'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
