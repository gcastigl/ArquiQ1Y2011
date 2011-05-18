

int strcmp(char * s1, char * s2){
	int ret = 0;
	
	while(ret == 0 && (*s1 != '\0' || *s2 != '\0')){
		ret = *s1 - *s2;
		s1++;s2++;
	}
	
	return ret;
}

int strncmp(char * s1, char * s2, unsigned int n){
	int ret = 0;
	int i;
	
	for(i=0;ret == 0 && i<=n && (*s1 != '\0' || *s2 != '\0'); i++)
		ret = *s1 - *s2;
		
	return ret;
}
