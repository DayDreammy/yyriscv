int main() {
    int a[5] = {0 };
    int i ,j,temp;
	int c=0;
	a[0]=5;
	a[1]=4;
	a[2]=1;
	a[3]=3;
	a[4]=2;
    
    for(i=0;i<5;i++){
    	for(j=0;j<5-1;j++)
    		if(a[j]>a[j+1]){
    			temp=a[j];
    			a[j]=a[j+1];
    			a[j+1]=temp;
			}
	}

	if(a[4]==5)
		c=1;

  return 0;
}
