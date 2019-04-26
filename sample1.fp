{Program Sample
	{Function facto VAL
		{if {< VAL 0 }
			then {= retVal -1}
		else 
			{= retVal 1}
		{while {> VAL 0} do
			{= retVal {* retVal VAL}}
			{= VAL {- VAL 1}}
		}
		}
		{if {== retVal (232451adfafwe\\32\\g2g23\\g32) and == retVal (\\)} 
			then {= retVal T}
		}
		return retVal
	}
	{print {facto 999}
	}
}

