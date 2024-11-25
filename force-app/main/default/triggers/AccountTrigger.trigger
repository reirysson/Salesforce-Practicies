/**
 * @description: Unique trigger for Account
 * @author: Reirysson Costa
 */
trigger AccountTrigger on Account (before insert, before update, after insert, after update) {
 
	new AccountHandler().run();
}