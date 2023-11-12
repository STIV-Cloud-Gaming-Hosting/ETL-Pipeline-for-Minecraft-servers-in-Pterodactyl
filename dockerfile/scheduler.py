import schedule, nbformat, time, os
from nbconvert.preprocessors import ExecutePreprocessor
from retry import retry

# Environment variables
PWD = os.path.dirname(os.path.realpath(__file__))
TZ = os.environ['TZ']
TIMEOUT = 1800 #(30 min)

@retry(tries=5, delay=10, backoff=2, max_delay=60)
def run_ipynb(filename_ipynb, timeout):
    with open(os.path.join(PWD, filename_ipynb)) as ff:
        nb = nbformat.read(ff, nbformat.NO_CONVERT)

    ep = ExecutePreprocessor(timeout=timeout, kernel_name='python3')
    ep.preprocess(nb)
    print(f'- {filename_ipynb} finished successfully')

# Schedule pterodactyl_application everyday
schedule.every().day.at("06:00").do(run_ipynb, filename_ipynb='pterodactyl_application.ipynb', timeout=TIMEOUT)
schedule.every().day.at("12:00").do(run_ipynb, filename_ipynb='pterodactyl_application.ipynb', timeout=TIMEOUT)
schedule.every().day.at("18:00").do(run_ipynb, filename_ipynb='pterodactyl_application.ipynb', timeout=TIMEOUT)
schedule.every().day.at("07:00").do(run_ipynb, filename_ipynb='pterodactyl_minecraft_logs.ipynb', timeout=TIMEOUT)
schedule.every(30).minutes.do(run_ipynb, filename_ipynb='pterodactyl_resource_consumption.ipynb', timeout=TIMEOUT)

# Run the scheduler loop
print('[The schedule has started]')
print(f'- The timezone is {TZ}')
for line in str(schedule.get_jobs())[1:-1].replace('), ','||').replace(' do ',' do||').replace('(last run:',' ||last run:').replace(', next run:','||next run:').split('||'):
    if line.startswith('Every'):
        print(f'\n{line}')
    else:
        print(f'  {line}')

print('')
while True:
    schedule.run_pending()
    time.sleep(600) # Wait 10 minutes before check again the tasks to run