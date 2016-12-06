#include <sourcemod>

public Plugin myinfo =
{
	name = "Admin logs",
	author = "maoling",
	description = "Admin logs",
	version = "1.0",
	url = "http://csgogamers.com"
};

Handle g_hDatabase = INVALID_HANDLE;
char g_szHostname[128];

public void OnPluginStart()
{
	char error[128];
	g_hDatabase = SQL_Connect("admin_logging", true, error, 128);		// U need put ur settings in databases.cfg
	if(g_hDatabase == INVALID_HANDLE)
		SetFailState("Database is not available.");
}

public void SQLCallback_Check(Handle owner, Handle hndl, const char[] error, any unused)
{
	if(hndl == INVALID_HANDLE)
		PrintToServer("Error happened: %s", error);
}

public Action OnLogAction(Handle source, Identity ident, int client, int target, const char[] message)
{
	if (client < 1 || GetUserAdmin(client) == INVALID_ADMIN_ID || g_hDatabase == INVALID_HANDLE)
		return Plugin_Continue;
	
	static bool hnRead = false;
	if(!hnRead)
	{
		char buffer[64];
		GetConVarString(FindConVar("hostname"), buffer, 64);
		SQL_EscapeString(g_hDatabase, buffer, g_szHostname, 128);
		hnRead = true;
	}

	char steamid[32];
	GetClientAuthId(client, AuthId_Steam2, steamid, 32, true);	

	char m_szQuery[512], emsg[512];
	SQL_EscapeString(g_hDatabase, message, emsg, 512);
	Format(m_szQuery, 512, "INSERT INTO `admin_log` VALUES (DEFAULT,'%s','%s','%s',DEFAULT);", g_szHostname, steamid, emsg);
	SQL_TQuery(g_hDatabase, SQLCallback_Check, m_szQuery);

	return Plugin_Handled;
}
