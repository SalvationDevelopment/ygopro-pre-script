--剛鬼死闘
--Gouki Deathmatch
--Script by nekrozar
function c100225012.initial_effect(c)
	c:EnableCounterPermit(0x146)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100225012.target)
	e1:SetOperation(c100225012.activate)
	c:RegisterEffect(e1)
	--remove counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100225012,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c100225012.rccon)
	e2:SetOperation(c100225012.rcop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100225012,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100225012.spcon)
	e3:SetTarget(c100225012.sptg)
	e3:SetOperation(c100225012.spop)
	c:RegisterEffect(e3)
end
function c100225012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanAddCounter(tp,0x146,3,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x146)
end
function c100225012.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x146,3)
	end
end
function c100225012.rccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE)
		and rc:IsFaceup() and rc:IsSetCard(0xfc) and rc:IsControler(tp)
end
function c100225012.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RemoveCounter(tp,0x146,3,REASON_EFFECT)
		c:RegisterFlagEffect(100225012,RESET_EVENT+0x1fe0000,0,0)
	end
end
function c100225012.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetCounter(0x146)==0 and c:GetFlagEffect(100225012)>2
end
function c100225012.spfilter(c,e,sp)
	return c:IsSetCard(0xfc) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c100225012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100225012.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_DECK)
end
function c100225012.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(c100225012.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if tg:GetCount()==0 or ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=nil
	if tg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=tg:Select(tp,ft,ft,nil)
	else
		g=tg
	end
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		c:AddCounter(0x146,3)
		c:ResetFlagEffect(100225012)
	end
end
