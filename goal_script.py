from csv import reader, writer
import csv
import random


def getPlayer(team, dic):
    lista = dic.get(team)

    return random.choice(lista)


def main():
    fileIn1 = open("add_players.csv", "r", encoding="utf8")
    fileIn2 = open("all_portuguese_results.csv", "r", encoding="utf8")
    fileIn3 = open("comandos.sql", "w", encoding="utf8")

    reader_jogadores = csv.reader(fileIn1, delimiter=",")
    reader_resultados = csv.reader(fileIn2, delimiter=",")

    myDict = {}
    lista = []
    for rowJogadores in reader_jogadores:
        equipa = rowJogadores[1]
        jogador = rowJogadores[0]
        # fileIn3.write("--equipa: %s jogador: %s\n" % (equipa, jogador))
        if equipa in myDict:
            # fileIn3.write("--equipa exists: %s\n" % (equipa))
            lista = myDict.get(equipa)
        
        else:
            lista = []

        lista.append(jogador)
        myDict[equipa] = lista

    # for key, value in myDict.items():
    #     fileIn3.write("--key: %s value: %s\n" % (key, value))

    # for row in reader1:

    #     print(','.join([row[0] , row[1]]))
    i = 0
    goals_teamH = []
    goals_teamA = []

    fileIn3.write("use top_5_futebol;\n")
    fileIn3.write("go\n")

    fileIn3.write("SET IDENTITY_INSERT gestao_futebol.jogo ON\n")

    id_jogo = 0
    for rowResults in reader_resultados:
        id_jogo = id_jogo + 1
        team_home = "'" + rowResults[1] + "'"
        team_away = "'" + rowResults[2] + "'"
        team_home_goals = int(rowResults[3])
        team_away_goals = int(rowResults[4])

        # criar jogo entre as duas equipas
        # argumentos:id_jogo, team_home, team_away
        fileIn3.write(
            "\nEXEC gestao_futebol.CriaJogo %d,%s,%s\n"
            % (id_jogo, team_home, team_away)
        )
        # fileIn3.write(str(team_home_goals) + "-" + str(team_away_goals) + "\n")

        # para cada golo
        # criar golo com id_jogo, minuto, Jogador

        fileIn3.write("--team_home: %s  team_away: %s \n" % (team_home, team_away))

        i = 0
        while i < team_home_goals:
            i = i + 1
            tamanho = len(myDict.get(team_home))
            fileIn3.write(
                "EXEC gestao_futebol.CriaGolo %d, %d, %s\n"
                % (id_jogo, random.randrange(0, 90), getPlayer(team_home, myDict))
            )

        i = 0
        while i < team_away_goals:
            i = i + 1
            tamanho = len(myDict.get(team_away))
            fileIn3.write(
                "EXEC gestao_futebol.CriaGolo %d, %d, %s\n"
                % (id_jogo, random.randrange(0, 90), getPlayer(team_away, myDict))
            )

        # i+=1
        # print(i)
        # for rowPlayers in reader1:
        # i+=1
        # print(i)
        # if rowResults[1] or rowResults[2] in rowPlayers[1]:

        # print(i)
        # print(goals_teamH + '-' + goals_teamA)
        # print('\n')

    # for a in goals_teamH:

    # print(a)

    fileIn3.write("SET IDENTITY_INSERT gestao_futebol.jogo OFF\n")
    fileIn3.close()


main()
