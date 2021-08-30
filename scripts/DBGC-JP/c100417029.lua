--運命の旅路
--
--Script by IceBarrierTrishula
function c100417029.initial_effect(c)
	aux.AddCodeList(c,100417125)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100417029,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,100417029)
	e1:SetTarget(c100417029.thtg)
	e1:SetOperation(c100417029.thop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100417029,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,100417029+100)
	e2:SetTarget(c100417029.eqtg)
	e2:SetOperation(c100417029.eqop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c100417029.indtg)
	e4:SetCountLimit(1)
	e4:SetValue(c100417029.indct)
	c:RegisterEffect(e4)
end
function c100417029.thfilter(c)
	return aux.IsCodeListed(c,100417125) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c100417029.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100417029.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c100417029.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100417029.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT)
	end
end
function c100417029.eqfilter(c,equip,tp)
	return c:IsType(TYPE_EQUIP) and aux.IsCodeListed(c,100417125)
		and (c:IsAbleToHand() or equip and c:CheckUniqueOnField(tp) and not c:IsForbidden())
end
function c100417029.cfilter(c)
	return c:IsCode(100417125) and c:IsFaceup()
end
function c100417029.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local equip=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(c100417029.cfilter,tp,LOCATION_MZONE,0,1,nil)
		return Duel.IsExistingMatchingCard(c100417029.eqfilter,tp,LOCATION_DECK,0,1,nil,equip,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c100417029.eqop(e,tp,eg,ep,ev,re,r,rp)
	local equip=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c100417029.cfilter,tp,LOCATION_MZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c100417029.eqfilter,tp,LOCATION_DECK,0,1,1,nil,equip,tp)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		if equip and tc:CheckUniqueOnField(tp) and not tc:IsForbidden()
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,aux.Stringid(100417029,2))==1) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local sc=Duel.SelectMatchingCard(tp,c100417029.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.Equip(tp,tc,sc:GetFirst())
		else
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c100417029.indtg(e,c)
	return c:GetEquipCount()>0
end
function c100417029.indct(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
