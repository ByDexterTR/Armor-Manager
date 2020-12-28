#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "Armor Manager", 
	author = "ByDexter", 
	description = "Armor Manager", 
	version = "1.0", 
	url = "https://steamcommunity.com/id/ByDexterTR - ByDexter#5494"
};

public void OnPluginStart()
{
	LoadTranslations("armormanager.phrases");
	LoadTranslations("common.phrases");
	RegAdminCmd("sm_armor", Command_Armor, ADMFLAG_SLAY, "sm_armor <#userid|name> [amount(0-100)]");
	RegAdminCmd("sm_helmet", Command_Helmet, ADMFLAG_SLAY, "sm_helmet <#userid|name> [amount(0-1)]");
	RegAdminCmd("sm_kevlar", Command_Helmet, ADMFLAG_SLAY, "sm_kevlar <#userid|name> [amount(0-1)]");
	RegAdminCmd("sm_resetarmor", Command_ResetArmor, ADMFLAG_SLAY, "sm_resetarmor <#userid|name>");
}

public Action Command_Armor(int client, int args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_armor <#userid|name> [amount(0-100)]");
		return Plugin_Handled;
	}
	
	char arg[65];
	GetCmdArg(1, arg, sizeof(arg));
	
	int amount = 0;
	if (args > 1)
	{
		char arg2[20];
		GetCmdArg(2, arg2, sizeof(arg2));
		if (StringToIntEx(arg2, amount) == 0)
		{
			ReplyToCommand(client, "[SM] %t", "Invalid Amount");
			return Plugin_Handled;
		}
		
		if (amount < 0)
		{
			amount = 0;
		}
		
		if (amount > 100)
		{
			amount = 100;
		}
	}
	
	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS], target_count;
	bool tn_is_ml;
	
	if ((target_count = ProcessTargetString(
				arg, 
				client, 
				target_list, 
				MAXPLAYERS, 
				COMMAND_FILTER_ALIVE, 
				target_name, 
				sizeof(target_name), 
				tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	for (int i = 0; i < target_count; i++)
	{
		SetEntProp(target_list[i], Prop_Data, "m_ArmorValue", amount, 4);
	}
	
	if (tn_is_ml)
	{
		ShowActivity2(client, "[SM] ", "%t", "Set armor on target", target_name, amount);
	}
	else
	{
		ShowActivity2(client, "[SM] ", "%t", "Set armor on target", "_s", target_name, amount);
	}
	
	return Plugin_Handled;
}

public Action Command_Helmet(int client, int args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_helmet <#userid|name> [amount(0-1)]");
		return Plugin_Handled;
	}
	
	char arg[65];
	GetCmdArg(1, arg, sizeof(arg));
	
	int amount = 0;
	if (args > 1)
	{
		char arg2[20];
		GetCmdArg(2, arg2, sizeof(arg2));
		if (StringToIntEx(arg2, amount) == 0)
		{
			ReplyToCommand(client, "[SM] %t", "Invalid Amount");
			return Plugin_Handled;
		}
		
		if (amount < 0)
		{
			amount = 0;
		}
		
		if (amount > 1)
		{
			amount = 1;
		}
	}
	
	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS], target_count;
	bool tn_is_ml;
	
	if ((target_count = ProcessTargetString(
				arg, 
				client, 
				target_list, 
				MAXPLAYERS, 
				COMMAND_FILTER_ALIVE, 
				target_name, 
				sizeof(target_name), 
				tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	for (int i = 0; i < target_count; i++)
	{
		SetEntProp(target_list[i], Prop_Data, "m_bHasHelmet", amount, 4);
	}
	
	if (amount == 1)
	{
		if (tn_is_ml)
		{
			ShowActivity2(client, "[SM] ", "%t", "Set helmet on target", target_name);
		}
		else
		{
			ShowActivity2(client, "[SM] ", "%t", "Set helmet on target", "_s", target_name);
		}
	}
	
	if (amount == 0)
	{
		if (tn_is_ml)
		{
			ShowActivity2(client, "[SM] ", "%t", "Set helmet off target", target_name);
		}
		else
		{
			ShowActivity2(client, "[SM] ", "%t", "Set helmet off target", "_s", target_name);
		}
	}
	
	return Plugin_Handled;
}

public Action Command_ResetArmor(int client, int args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_resetarmor <#userid|name>");
		return Plugin_Handled;
	}
	
	char arg[65];
	GetCmdArg(1, arg, sizeof(arg));
	
	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS], target_count;
	bool tn_is_ml;
	
	if ((target_count = ProcessTargetString(
				arg, 
				client, 
				target_list, 
				MAXPLAYERS, 
				COMMAND_FILTER_ALIVE, 
				target_name, 
				sizeof(target_name), 
				tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}
	
	for (int i = 0; i < target_count; i++)
	{
		SetEntProp(target_list[i], Prop_Send, "m_bHasHelmet", 0);
		SetEntProp(target_list[i], Prop_Send, "m_ArmorValue", 0, 0);
		if (GetEngineVersion() == Engine_CSGO)
		{
			SetEntProp(target_list[i], Prop_Send, "m_bHasHeavyArmor", 0);
			SetEntProp(target_list[i], Prop_Send, "m_bWearingSuit", 0);
		}
	}
	
	if (tn_is_ml)
	{
		ShowActivity2(client, "[SM] ", "%t", "Remove armor on target", target_name);
	}
	else
	{
		ShowActivity2(client, "[SM] ", "%t", "Remove armor on target", "_s", target_name);
	}
	return Plugin_Handled;
} 