
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("Макет, Заголовок", "НастройкаЭлементовФормыИКопированиеНастроек", НСтр("ru = 'Настройка элементов формы и копирование настроек другим пользователям'"));
	ОткрытьФорму("Обработка.CRM_БыстроеОсвоение.Форма",ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
