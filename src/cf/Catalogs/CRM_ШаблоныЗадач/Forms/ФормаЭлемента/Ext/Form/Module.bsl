////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура УстановитьСвойстваЭлементовФормы()
	
	Элементы.ГруппаКоманд.Видимость = (Объект.КаналОповещения = Перечисления.CRM_КаналыОповещений.ЭлектроннаяПочта);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьТекстИВложения()
	
	Если Объект.КаналОповещения = Перечисления.CRM_КаналыОповещений.ЭлектроннаяПочта Тогда
		ФорматированныйДокументТекст.ПолучитьHTML(Объект.Текст, Новый Структура);
	Иначе
		Объект.Текст = ФорматированныйДокументТекст.ПолучитьТекст();
	КонецЕсли;
	
КонецПроцедуры

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Объект.Ссылка.Пустая() Тогда
		Если Объект.КаналОповещения = Перечисления.CRM_КаналыОповещений.ЭлектроннаяПочта Тогда
			ФорматированныйДокументТекст.УстановитьHTML(Объект.Текст, Новый Структура());
		Иначе
			ФорматированныйДокументТекст.Добавить(Объект.Текст);
		КонецЕсли;
	Иначе
		Объект.КаналОповещения = Перечисления.CRM_КаналыОповещений.ЭлектроннаяПочта;
	КонецЕсли;
	
	УстановитьСвойстваЭлементовФормы();
	
	// АВТОТЕКСТ
	ТаблицаАвтотекстаЗнач = РеквизитФормыВЗначение("ТаблицаАвтотекста");
	CRM_АвтотекстПереопределяемый.СформироватьСписокАвтотекста(ТаблицаАвтотекстаЗнач, Перечисления.CRM_НазначенияАвтотекста.АвтотекстЗадачаИсполнителя);
	CRM_АвтотекстПереопределяемый.СформироватьСписокАвтотекста(ТаблицаАвтотекстаЗнач, Перечисления.CRM_НазначенияАвтотекста.АвтотекстЗадачаИсполнителя, Истина);
	ЗначениеВРеквизитФормы(ТаблицаАвтотекстаЗнач, "ТаблицаАвтотекста");
	
	CRM_АвтотекстПереопределяемый.ЗаполнитьКоманднуюПанельФорматированногоДокумента(ЭтотОбъект, Истина);
	CRM_АвтотекстПереопределяемый.ЗаполнитьКоманднуюПанельФорматированногоДокумента(ЭтотОбъект, Ложь,,Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СформироватьТекстИВложения();
	
КонецПроцедуры

&НаКлиенте
Процедура КаналОповещенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокКаналов = Новый СписокЗначений;
	СписокКаналов.Добавить(ПредопределенноеЗначение("Перечисление.CRM_КаналыОповещений.ЭлектроннаяПочта"));
	СписокКаналов.Добавить(ПредопределенноеЗначение("Перечисление.CRM_КаналыОповещений.СМС"));
	
	ДанныеВыбора = СписокКаналов;
	
КонецПроцедуры

&НаСервере
Процедура СменитьТекстДокумента()
	
	Если Объект.КаналОповещения = Перечисления.CRM_КаналыОповещений.ЭлектроннаяПочта Тогда
		ФорматированныйДокументТекст.ПолучитьHTML(ТекстПисьма, Новый Структура);
		ФорматированныйДокументТекст.Удалить();
		ФорматированныйДокументТекст.Добавить(ТекстСМС);
	Иначе
		ТекстСМС = ФорматированныйДокументТекст.ПолучитьТекст();
		ФорматированныйДокументТекст.Удалить();
		ФорматированныйДокументТекст.УстановитьHTML(ТекстПисьма,  Новый Структура);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КаналОповещенияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если НЕ Объект.КаналОповещения = ВыбранноеЗначение Тогда
		СменитьТекстДокумента();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КаналОповещенияПриИзменении(Элемент)
	УстановитьСвойстваЭлементовФормы();
КонецПроцедуры

&НаСервере
Процедура ВставитьТэгВФорматированныйДокумент(ИмяКоманды)
	
	МассивСтрок = ТаблицаАвтотекста.НайтиСтроки(Новый Структура("ИмяКоманды",ИмяКоманды));
	Тэг = МассивСтрок[0].Тэг;
	
	ПозицияНачала		= 0;
	ПозицияОкончания	= 0;
	Элементы.ФорматированныйДокументТекст.ПолучитьГраницыВыделения(ПозицияНачала,ПозицияОкончания);
	Начало		= ФорматированныйДокументТекст.ПолучитьПозициюПоЗакладке(ПозицияНачала);
	Окончание	= ФорматированныйДокументТекст.ПолучитьПозициюПоЗакладке(ПозицияОкончания);
	Если НЕ Начало = Окончание Тогда
		ФорматированныйДокументТекст.Удалить(ПозицияНачала, ПозицияОкончания);
		ПозицияОкончания = ФорматированныйДокументТекст.ПолучитьЗакладкуПоПозиции(Начало);
	КонецЕсли;
	ФорматированныйДокументТекст.Вставить(ПозицияОкончания, Тэг);
	
КонецПроцедуры

&НаСервере
Процедура ВставитьТэгВПолеТемы(ИмяКоманды)
	
	МассивСтрок = ТаблицаАвтотекста.НайтиСтроки(Новый Структура("ИмяКоманды",ИмяКоманды));
	Тэг = МассивСтрок[0].Тэг;
	
	Объект.Тема = Объект.Тема + Тэг;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВставитьТэг(Команда)
	
	Если Лев(Команда.Имя,4) = "Тема" Тогда
		ВставитьТэгВПолеТемы(Команда.Имя);
	Иначе
		ВставитьТэгВФорматированныйДокумент(Команда.Имя);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
