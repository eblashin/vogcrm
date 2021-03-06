
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Константа.ПровайдерSMS");
	УстановитьПривилегированныйРежим(Истина);
	НастройкиПровайдера = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Пароль, Логин, ИмяОтправителя");
	УстановитьПривилегированныйРежим(Ложь);
	ЛогинДляОтправкиSMS = НастройкиПровайдера.Логин;
	ИмяОтправителя = НастройкиПровайдера.ИмяОтправителя;
	ПарольДляОтправкиSMS = ?(ЗначениеЗаполнено(НастройкиПровайдера.Пароль), ЭтотОбъект.УникальныйИдентификатор, "");
	
	Если НаборКонстант.ПровайдерSMS = Перечисления.ПровайдерыSMS.GSMINFORM Тогда
		Элементы.ЛогинДляОтправкиSMS.Заголовок = НСтр("ru = 'ID кабинета'");
		Элементы.ПарольДляОтправкиSMS.Заголовок = НСтр("ru = 'API-ключ'");
		Элементы.ИмяОтправителя.АвтоОтметкаНезаполненного = Истина;
	Иначе
		Элементы.ЛогинДляОтправкиSMS.Заголовок = НСтр("ru = 'Логин'");
		Элементы.ПарольДляОтправкиSMS.Заголовок = НСтр("ru = 'Пароль'");
		Элементы.ИмяОтправителя.АвтоОтметкаНезаполненного = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьПовторноИспользуемыеЗначения();
	Оповестить("Запись_НастройкиОтправкиSMS", ПараметрыЗаписи, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	УстановитьПривилегированныйРежим(Истина);
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Константа.ПровайдерSMS");
	Если ПарольДляОтправкиSMS <> Строка(ЭтотОбъект.УникальныйИдентификатор) Тогда
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, ПарольДляОтправкиSMS);
	КонецЕсли;
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, ЛогинДляОтправкиSMS, "Логин");
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, ИмяОтправителя, "ИмяОтправителя");
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПровайдерSMSПриИзменении(Элемент)
	ЛогинДляОтправкиSMS = "";
	ПарольДляОтправкиSMS = "";
	ИмяОтправителя = "";
	
	Если НаборКонстант.ПровайдерSMS = ПредопределенноеЗначение("Перечисление.ПровайдерыSMS.GSMINFORM") Тогда
		Элементы.ЛогинДляОтправкиSMS.Заголовок = НСтр("ru = 'ID кабинета'");
		Элементы.ПарольДляОтправкиSMS.Заголовок = НСтр("ru = 'API-ключ'");
		Элементы.ИмяОтправителя.АвтоОтметкаНезаполненного = Истина;
	Иначе
		Элементы.ЛогинДляОтправкиSMS.Заголовок = НСтр("ru = 'Логин'");
		Элементы.ПарольДляОтправкиSMS.Заголовок = НСтр("ru = 'Пароль'");
		Элементы.ИмяОтправителя.АвтоОтметкаНезаполненного = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеУслугиНажатие(Элемент)
	Если НаборКонстант.ПровайдерSMS = ПредопределенноеЗначение("Перечисление.ПровайдерыSMS.Билайн") Тогда
		ПерейтиПоНавигационнойСсылке("http://b2b.beeline.ru/msk/sb/mobile/services/index.wbp?id=3a15308a-7b14-4f8e-acda-0841dd6c750e");
	ИначеЕсли НаборКонстант.ПровайдерSMS = ПредопределенноеЗначение("Перечисление.ПровайдерыSMS.МТС") Тогда
		ПерейтиПоНавигационнойСсылке("http://www.mtscommunicator.ru/service/");
	ИначеЕсли НаборКонстант.ПровайдерSMS = ПредопределенноеЗначение("Перечисление.ПровайдерыSMS.SMSRU") Тогда
		ПерейтиПоНавигационнойСсылке("http://sms.ru");
	ИначеЕсли НаборКонстант.ПровайдерSMS = ПредопределенноеЗначение("Перечисление.ПровайдерыSMS.SMSЦЕНТР") Тогда
		ПерейтиПоНавигационнойСсылке("http://smsc.ru");
	ИначеЕсли НаборКонстант.ПровайдерSMS = ПредопределенноеЗначение("Перечисление.ПровайдерыSMS.СМСУслуги") Тогда
		ПерейтиПоНавигационнойСсылке("http://sms-uslugi.ru");
	ИначеЕсли НаборКонстант.ПровайдерSMS = ПредопределенноеЗначение("Перечисление.ПровайдерыSMS.GSMINFORM") Тогда
		ПерейтиПоНавигационнойСсылке("http://gsm-inform.ru");
	Иначе
		АдресВИнтернете = "";
		ОтправкаSMSКлиентПереопределяемый.ПриПолученииАдресаПровайдераВИнтернете(НаборКонстант.ПровайдерSMS, АдресВИнтернете);
		Если Не ПустаяСтрока(АдресВИнтернете) Тогда
			ПерейтиПоНавигационнойСсылке(АдресВИнтернете);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
