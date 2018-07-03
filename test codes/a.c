#include <stdio.h>
enum days{mon,tue,wed};

char* translateFlagsToString(unsigned long flag){
	switch(flag){
		case 0:
			return "PG_locked";
		case 1:
			return 	"PG_error";
		case 2:
			return 	"PG_referenced";
		case 3:
			return 	"PG_uptodate";
		case 4:
			return 	"PG_dirty";
		case 5:
			return 	"PG_lru";
		case 6:
			return 	"PG_active";
		case 7:
			return 	"PG_waiters";
		case 8:
			return 	"PG_slab";
		case 9:
			return 	"PG_owner_priv_1";
		case 10:
			return 	"PG_arch_1";
		case 11:
			return 	"PG_reserved";
		case 12:
			return 	"PG_private";
		case 13:
			return 	"PG_private_2";
		case 14:
			return 	"PG_writeback";
		case 15:
			return 	"PG_head";
		case 16:
			return 	"PG_mappedtodisk";
		case 17:
			return 	"PG_reclaim";		
		case 18:
			return 	"PG_swapbacked";
		case 19:
			return 	"PG_unevictable";
	}
}
int main(){
	int day = 1;
	enum days a = day;
	printf("%s\n", translateFlagsToString(2));
	return 0;
}
