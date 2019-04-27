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
		{if {and {== VAL (aabb\\\cc)} {!= VAL T} }
			then {= retVal 3.5}
		else 
			{= VV F}
		}
		return retVal
	}
	{print {facto 999}
	}
}