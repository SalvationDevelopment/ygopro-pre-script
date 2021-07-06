--レプティレス・コアトル
--scripted by XyLeN
function c101106020.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101106020)
	e1:SetCondition(c101106020.spcon)
	e1:SetTarget(c101106020.sptg)
	e1:SetOperation(c101106020.spop)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetValue(c101106020.ntval)
	c:RegisterEffect(e2)
end
function c101106020.cfilter(c) 
	return c:IsFaceup() and c:IsRace(RACE_REPTILE) 
end
function c101106020.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101106020.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101106020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101106020.cgfilter(c) 
	return c:IsFaceup() and c:IsAttack(0)
end
function c101106020.spfilter(c,e,tp)
	return c:IsSetCard(SET_REPTILIANNE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101106020.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local cg=Duel.GetMatchingGroup(c101106020.cgfilter,tp,0,LOCATION_MZONE,nil)
		local ct=math.min(#cg,(Duel.GetLocationCount(tp,LOCATION_MZONE)))
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
		local g=Duel.GetMatchingGroup(c101106020.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		if g:GetCount()>0 and ct>0 and Duel.SelectYesNo(tp,aux.Stringid(101106020,1)) then
			Duel.BreakEffect()
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,ct,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c101106020.ntval(e,c)
	return e:GetHandler():IsControler(c:GetControler()) and c:IsRace(RACE_REPTILE)
end
