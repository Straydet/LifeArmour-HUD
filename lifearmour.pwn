/*


		LifeArmour HUD v1.0
		
		
        Este sistema de barras de Vida y Chaleco añade un HUD dinámico que muestra en tiempo real la salud y la armadura del jugador.
		Las barras y textdraws se actualizan automáticamente mediante un temporizador, ofreciendo rendimiento estable y ocultando el chaleco cuando su valor llega a cero.
		Además, los jugadores pueden personalizar el color de sus indicadores con una paleta de tonos clásicos y pastel, logrando una interfaz moderna y configurable.


		Nota: Se ha dejado algunas instrucciones/comentarios por el sistema para que sea más legible a la hora de hacer cambios.
		En caso de encontrar un bug/error puede notificarlo asi también como sugerencias para el sistema.
	    Si quiere modificar/editar debe al menos conocer el lenguaje 'Pawn', ya que puede causar errores/bugs por no saber lo que hace.
	    

		Desarrollador -> (Straydet)
		
		Tiempo estimado de compilación: 6 segundos

*/

#include <a_samp>
#include <progress2>
#include <zcmd>
#include <sscanf2>


#define DIALOG_COLORVIDA 		2800
#define DIALOG_COLORARMOUR 		2801

new PlayerBar:PlayerProgressBar[MAX_PLAYERS][2];

new PlayerText:armourbarx[MAX_PLAYERS];
new PlayerText:healthbarx[MAX_PLAYERS];

public OnFilterScriptInit() //Puedes cambiar esto por OnFilterScriptInit - OnGameModeInit
{
	return 1;
}

public OnFilterScriptExit() //Puedes cambiar esto por OnFilterScriptExit - OnGameModeExit
{
	return 1;
}


public OnPlayerConnect(playerid)
{
	//Vida
	PlayerProgressBar[playerid][0] = CreatePlayerProgressBar(playerid, 546.000000, 65.000000, 64.000000, 10.500000, 2091670271, 100.000000, 0);
	SetPlayerProgressBarValue(playerid, PlayerProgressBar[playerid][0], 50.000000);

	//Chaleco
	PlayerProgressBar[playerid][1] = CreatePlayerProgressBar(playerid, 546.000000, 41.000000, 64.000000, 10.500000, -741092353, 100.000000, 0);
	SetPlayerProgressBarValue(playerid, PlayerProgressBar[playerid][1], 50.000000);
	
	armourbarx[playerid] = CreatePlayerTextDraw(playerid, 609.000000, 38.500000, "100"); //Chaleco
	PlayerTextDrawLetterSize(playerid, armourbarx[playerid], 0.362500, 1.450000);
	PlayerTextDrawTextSize(playerid, armourbarx[playerid], 10.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, armourbarx[playerid], 1);
	PlayerTextDrawColor(playerid, armourbarx[playerid], 0xB7B7B7FF);
	PlayerTextDrawUseBox(playerid, armourbarx[playerid], 0);
	PlayerTextDrawBoxColor(playerid, armourbarx[playerid], 0x80808080);
	PlayerTextDrawSetShadow(playerid, armourbarx[playerid], 1);
	PlayerTextDrawSetOutline(playerid, armourbarx[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, armourbarx[playerid], 0x000000FF);
	PlayerTextDrawFont(playerid, armourbarx[playerid], 3);
	PlayerTextDrawSetProportional(playerid, armourbarx[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, armourbarx[playerid], 0);
	
	healthbarx[playerid] = CreatePlayerTextDraw(playerid, 609.000000, 62.500000, "100"); //Vida
	PlayerTextDrawLetterSize(playerid, healthbarx[playerid], 0.362500, 1.450000);
	PlayerTextDrawTextSize(playerid, healthbarx[playerid], 10.000000, 10.000000);
	PlayerTextDrawAlignment(playerid, healthbarx[playerid], 1);
	PlayerTextDrawColor(playerid, healthbarx[playerid], 0x7CAC5AAA);
	PlayerTextDrawUseBox(playerid, healthbarx[playerid], 0);
	PlayerTextDrawBoxColor(playerid, healthbarx[playerid], 0x80808080);
	PlayerTextDrawSetShadow(playerid, healthbarx[playerid], 1);
	PlayerTextDrawSetOutline(playerid, healthbarx[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, healthbarx[playerid], 0x000000FF);
	PlayerTextDrawFont(playerid, healthbarx[playerid], 3);
	PlayerTextDrawSetProportional(playerid, healthbarx[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, healthbarx[playerid], 0);

	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	DestroyPlayerProgressBar(playerid, PlayerProgressBar[playerid][0]);
	DestroyPlayerProgressBar(playerid, PlayerProgressBar[playerid][1]);
	return 1;
}


public OnPlayerSpawn(playerid)
{
    ShowPlayerProgressBar(playerid, PlayerProgressBar[playerid][0]);
	ShowPlayerProgressBar(playerid, PlayerProgressBar[playerid][1]);
	
	PlayerTextDrawShow(playerid, healthbarx[playerid]);
	PlayerTextDrawShow(playerid, armourbarx[playerid]);
	return 1;
}

public OnPlayerUpdate(playerid)
{
    new Float:health, Float:armour;
    GetPlayerHealth(playerid, health);
    GetPlayerArmour(playerid, armour);

    // Actualizar barras
    SetPlayerProgressBarValue(playerid, PlayerProgressBar[playerid][0], health);   // Barra de vida

    // Actualizar textdraws con números enteros
    new str[8];
    format(str, sizeof(str), "%d", floatround(health));
    PlayerTextDrawSetString(playerid, healthbarx[playerid], str);

    format(str, sizeof(str), "%d", floatround(armour));
    PlayerTextDrawSetString(playerid, armourbarx[playerid], str);
    
    if(armour > 0.0)
    {
        SetPlayerProgressBarValue(playerid, PlayerProgressBar[playerid][1], armour);
        format(str, sizeof(str), "%d", floatround(armour));
        PlayerTextDrawSetString(playerid, armourbarx[playerid], str);

        ShowPlayerProgressBar(playerid, PlayerProgressBar[playerid][1]);
        PlayerTextDrawShow(playerid, armourbarx[playerid]);
    }
    else
    {
        HidePlayerProgressBar(playerid, PlayerProgressBar[playerid][1]);
        PlayerTextDrawHide(playerid, armourbarx[playerid]);
    }


    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_COLORVIDA && response)
    {
        new color;
        switch(listitem)
        {
            case 0: color = 0xFF0000FF; // Rojo
            case 1: color = 0x7CAC5AFF; // Verde
            case 2: color = 0x6A9CFFFF; // Azul
            case 3: color = 0xFFF68AFF; // Amarillo
            case 4: color = 0xB7B7B7FF; // Blanco
            case 5: color = 0xC68CFFFF; // Morado
        }

        // Cambiar color de la barra de vida
        SetPlayerProgressBarColour(playerid, PlayerProgressBar[playerid][0], color);
        HidePlayerProgressBar(playerid, PlayerProgressBar[playerid][0]);
        ShowPlayerProgressBar(playerid, PlayerProgressBar[playerid][0]);

        // Cambiar color del textdraw de vida
        PlayerTextDrawColor(playerid, healthbarx[playerid], color);
        PlayerTextDrawHide(playerid, healthbarx[playerid]);
        PlayerTextDrawShow(playerid, healthbarx[playerid]);

        SendClientMessage(playerid, -1, "* Has cambiado el color de la barra de vida.");
    }
    //------------------------------------------------------------------------//
    if(dialogid == DIALOG_COLORARMOUR && response)
    {
        new color;
        switch(listitem)
        {
            case 0: color = 0xFFFFFFFF; // Blanco
            case 1: color = 0xFF6A6AFF; // Rojo (Pastel)
            case 2: color = 0x7CAC5AFF; // Verde
            case 3: color = 0x6A9CFFFF; // Azul
            case 4: color = 0xFFF68AFF; // Amarillo
            case 5: color = 0xC68CFFFF; // Morado
            case 6: color = 0x8CFBFFFF; // Cyan
            case 7: color = 0xFFB47CFF; // Naranja
        }
        
        // Cambiar color de la barra de chaleco
        SetPlayerProgressBarColour(playerid, PlayerProgressBar[playerid][1], color);
        HidePlayerProgressBar(playerid, PlayerProgressBar[playerid][1]);
        ShowPlayerProgressBar(playerid, PlayerProgressBar[playerid][1]);

        // Cambiar color del textdraw de chaleco
        PlayerTextDrawColor(playerid, armourbarx[playerid], color);
        PlayerTextDrawHide(playerid, armourbarx[playerid]);
        PlayerTextDrawShow(playerid, armourbarx[playerid]);

        SendClientMessage(playerid, -1, "* Has cambiado el color de la barra de chaleco.");
    }
    
    return 1;
}


CMD:colorvida(playerid, params[])
{
    ShowPlayerDialog(playerid, DIALOG_COLORVIDA, DIALOG_STYLE_LIST,
        "Selecciona color de la barra de vida",
        "{FF0000}Rojo\n{7CAC5A}Verde\n{6A9CFF}Azul\n{FFF68A}Amarillo\n{B7B7B7}Blanco\n{C68CFF}Morado",
        "Seleccionar", "Cancelar");
    return 1;
}

CMD:colorarmour(playerid, params[])
{
    ShowPlayerDialog(playerid, DIALOG_COLORARMOUR, DIALOG_STYLE_LIST,
        "Selecciona color de la barra de chaleco",
        "{FFFFFF}Blanco (default)\n{FF6A6A}Rojo\n{7CAC5A}Verde\n{6A9CFF}Azul\n{FFF68A}Amarillo\n{C68CFF}Morado\n{8CFBFF}Cyan\n{FFB47C}Naranja",
        "Seleccionar", "Cancelar");
    return 1;
}


// Puede quitar los /* y */ para usar los comandos y probar el sistema

// Comando para dar vida
/*CMD:sethp(playerid, params[])
{
    new targetid, value;
    if(sscanf(params, "ui", targetid, value)) return SendClientMessage(playerid, -1, "Uso: /sethp [playerid] [valor]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "Jugador no conectado.");

    SetPlayerHealth(targetid, float(value));
    SendClientMessage(playerid, -1, "Has establecido la vida del jugador.");
    return 1;
}*/

// Comando para dar chaleco
/*CMD:setarmour(playerid, params[])
{
    new targetid, value;
    if(sscanf(params, "ui", targetid, value)) return SendClientMessage(playerid, -1, "Uso: /setarmour [playerid] [valor]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "Jugador no conectado.");

    SetPlayerArmour(targetid, float(value));
    SendClientMessage(playerid, -1, "Has establecido el chaleco del jugador.");
    return 1;
}*/
