
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("Макет, Заголовок", "РаботаСОтчетами", НСтр("ru = 'Работа с отчетами'"));
	ОткрытьФорму("Обработка.CRM_БыстроеОсвоение.Форма",ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
