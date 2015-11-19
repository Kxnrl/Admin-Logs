#include <sourcemod>

public Plugin:myinfo =
{
	name = "Admin logs",
	author = "maoling",
	description = "Admin logs",
	version = "1.0",
	url = "http://csgogamers.com"
};

new Handle:g_lDatabase = INVALID_HANDLE;
new String:g_ehostName[128];

public OnPluginStart(){
	CreateConVar("sm_adminlogs_version","1.0","The version of admin logs.",FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);

	new String:error[255];
	g_lDatabase = SQL_Connect("admin_logging", true, error, sizeof(error));		// U need put ur settings in databases.cfg
	if(g_lDatabase == INVALID_HANDLE)
	{
		PrintToServer("Could not connect to database: %s", error);
	}
}

public SQLCallback_Check(Handle:owner, Handle:hndl, const String:error[], any:unused)
{
	if(hndl==INVALID_HANDLE)
	{
		PrintToServer("Error happened: %s", error);
		return;
	}
}

public Action:OnLogAction(Handle:source,
                          Identity:ident,
                          client,
                          target,
                          const String:message[])
{
	if (client < 1 || GetUserAdmin(client) == INVALID_ADMIN_ID
		|| g_lDatabase == INVALID_HANDLE || StrContains(message, "toggled noclip") >= 0)   // Ignore noclip , if u want , delete " || StrContains(message, "toggled noclip") >= 0"
	{
		return Plugin_Continue;
	}
	
	static hnRead = false;
	if (!hnRead) {
		new Handle:cvHostname = FindConVar("hostname");
		if (cvHostname != INVALID_HANDLE)
		{
			decl String:buffer[64];
			GetConVarString(cvHostname, buffer, 64);
			SQL_EscapeString(g_lDatabase, buffer, g_ehostName, 128);
		}
		hnRead = true;
	}

	decl String:steamid[32];
	GetClientAuthString(client, steamid, sizeof(steamid));	

	decl String:m_iQuery[255];
	decl String:emsg[255];
	SQL_EscapeString(g_lDatabase, message, emsg, 255);
	Format(m_iQuery, sizeof(m_iQuery), "INSERT INTO `admin_log` VALUES (DEFAULT,'%s','%s','%s',DEFAULT);", g_ehostName, steamid, emsg);
	SQL_TQuery(g_lDatabase, SQLCallback_Check, m_iQuery);

	return Plugin_Handled;
}
