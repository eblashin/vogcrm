
#Область СлужебныеПроцедурыИФункции

Функция ДобавлениеИзменениеНастройкиПечатиОбъектов(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеНастройкиПечатиОбъектов", Пользователь, Ложь);
КонецФункции

Функция СохранениеНастроекПечатиОбъектовПоУмолчанию(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("СохранениеНастроекПечатиОбъектовПоУмолчанию", Пользователь, Ложь);
КонецФункции

#КонецОбласти
