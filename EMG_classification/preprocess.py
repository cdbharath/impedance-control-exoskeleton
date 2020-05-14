import glob

files = glob.glob('./data/*all.wav')

sample_rate = 24000

for f in files:
    file_object = open('./annotations/'+str((f.split('/')[-1])[:-4])+'.txt','w+')

    count = 0
    ang = '0'
    for i in range(120*sample_rate):
        
        if(i%(sample_rate*5)==0):
            count = count + 1
            if(count==1):
                ang = '0'
            elif(count==2):
                ang = '30'
            elif(count==3):
                ang = '90'
            elif(count==4):
                ang = '150'
            elif(count==5):
                ang = '90'
            elif(count==6):
                ang = '30'
            
            elif(count==7):
                ang = '0'
            
            elif(count>7):
                ang = '0'                    
        file_object.write(ang +'\n')

    file_object.close()