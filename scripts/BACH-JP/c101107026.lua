--模拘撮星人 エピゴネン
--
--Script by Trishula9
function c101107026.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c101107026.spcost)
	e1:SetTarget(c101107026.sptg)
	e1:SetOperation(c101107026.spop)
	c:RegisterEffect(e1)
end
function c101107026.costfilter(c,tp)
	return c:IsType(TYPE_EFFECT) and Duel.GetMZoneCount(tp,c)>1
end
function c101107026.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101107026.costfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c101107026.costfilter,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetRace())
	e:SetValue(g:GetFirst():GetAttribute())
	Duel.Release(g,REASON_COST)
end
function c101107026.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101107126,0,TYPES_TOKEN_MONSTER,0,0,1,e:GetLabel(),e:GetValue()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c101107026.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101107126,0,TYPES_TOKEN_MONSTER,0,0,1,e:GetLabel(),e:GetValue()) then
		Duel.BreakEffect()
		local token=Duel.CreateToken(tp,101107126)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(e:GetValue())
		token:RegisterEffect(e2)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)	   
	end
end