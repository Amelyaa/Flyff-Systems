USE [CHARACTER_01_DBF]
GO
/****** Object:  StoredProcedure [dbo].[ITEM_COUNT]    Script Date: 02/05/2020 17:57:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ITEM_COUNT]
	@iserverindex	CHAR(2),
	@idItem			CHAR(10)
AS
BEGIN
	-- nombre de fois que l'item est present
	DECLARE @count INT;
	SET @count = 0;

	-- loop sur tous les joueurs
	DECLARE @itCharacter VARCHAR(500);
	DECLARE cursorCharacter CURSOR FOR
		-- recuperation de la liste des joueurs
		SELECT m_idPlayer FROM dbo.CHARACTER_TBL WHERE serverindex=@iserverindex;
		OPEN cursorCharacter
		FETCH cursorCharacter INTO @itCharacter

		-- loop sur tous les joueurs
		WHILE @@FETCH_STATUS = 0
			BEGIN
				-- Inventaire du joueur
				SET @count += dbo.fn_item_count_character_inventory(@itCharacter, @iserverindex, @idItem);
				-- Banque du joueur
				SET @count += dbo.fn_item_count_character_bank_inventory(@itCharacter, @iserverindex, @idItem);
				FETCH cursorCharacter INTO @itCharacter
			END
	CLOSE cursorCharacter
	DEALLOCATE cursorCharacter


	-- loop sur tous guild
	DECLARE @itGuild VARCHAR(500);
	DECLARE cursorGuild CURSOR FOR
		-- recuperation de la liste des guildes
		SELECT m_idGuild FROM dbo.GUILD_BANK_TBL WHERE serverindex=@iserverindex;
		OPEN cursorGuild
		FETCH cursorGuild INTO @itGuild

		-- loop sur toutes les guildes
		WHILE @@FETCH_STATUS = 0
			BEGIN
				-- Banque GUILD
				SET @count += dbo.fn_item_count_guild_bank(@itGuild, @iserverindex, @idItem);
				FETCH cursorGuild INTO @itGuild
			END
	CLOSE cursorGuild
	DEALLOCATE cursorGuild


	RETURN @count;
END


