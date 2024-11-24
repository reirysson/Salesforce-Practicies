/**
 * @description: Unique trigger for Account
 * @author: Reirysson Costa
 */
trigger AccountTrigger on Account (before insert, before update) {
 
	new AccountHandler().run();
}