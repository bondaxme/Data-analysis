import csv
from datetime import datetime

def format_date(row_name, source, dest, start_date_format, flag):
    with open(source, 'r') as csvfile:
        reader = csv.DictReader(csvfile)

        with open(dest, 'w', newline='') as outfile:
            fieldnames = reader.fieldnames
            writer = csv.DictWriter(outfile, fieldnames=fieldnames)
            writer.writeheader()
            for row in reader:
                date_str = row[row_name]
                date = datetime.strptime(date_str, start_date_format)
                updated_date_str = date.strftime('%Y-%m-%d')
                row[row_name] = updated_date_str
                if flag == 1:
                    old_value = row['match_id']
                    new_value = old_value[2:]
                    row['match_id'] = new_value
                writer.writerow(row)

def format_stadiums_names():
    with open('matches.csv', 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        rows = list(reader)

    for row in rows:
        if row['home_team'] == 'RB Leipzig' and row['stadium'] == 'Red Bull Arena':
            row['stadium'] = 'Red Bull Arena (Leipzig)'
        elif row['home_team'] == 'RB Salzburg' and row['stadium'] == 'Red Bull Arena':
            row['stadium'] = 'Red Bull Arena (Salzburg)'

    with open('matches.csv', 'w', newline='') as csvfile:
        fieldnames = ['id', 'season', 'date_time', 'home_team', 'away_team', 'stadium', 'home_team_score',
                      'away_team_score', 'penalty_shoot_out', 'attendance']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for row in rows:
            writer.writerow(row)


format_date('date_of_birth', 'managers.csv', 'updated_managers.csv', '%m-%d-%Y', 0)
format_date('date_time', 'matches.csv', 'updated_matches.csv', '%d-%b-%y %I.%M.%S.%f000000 PM', 1)
format_stadiums_names()



