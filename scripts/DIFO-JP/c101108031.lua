--リバースポッド

--Script by Chrono-Genex
function c101108031.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101108031,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101108031)
	e1:SetTarget(c101108031.target)
	e1:SetOperation(c101108031.operation)
	c:RegisterEffect(e1)
end
function c101108031.thfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c101108031.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g1=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local g2=Duel.GetMatchingGroup(c101108031.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,g2:GetCount(),0,0)
end
function c101108031.ctfilter(c,tp)
	return c:IsLocation(LOCATION_HAND) and c:IsControler(tp)
end
function c24010609.fselect(g,ft)
	local fc=g:FilterCount(Card.IsType,nil,TYPE_FIELD)
	return fc<=1 and #g-fc<=ft
end
function c101108031.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	if g:GetCount()>0 and Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 then
		local rg=Duel.GetMatchingGroup(c101108031.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if rg:GetCount()>0 then
			Duel.BreakEffect()
			if Duel.SendtoHand(rg,nil,REASON_EFFECT)==0 then return end
			local og=Duel.GetOperatedGroup()
			local turnp=Duel.GetTurnPlayer()
			local setg1=Group.CreateGroup()
			local sg1=Duel.GetMatchingGroup(Card.IsSSetable,turnp,LOCATION_HAND,0,nil)
			local ct1=og:FilterCount(c101108031.ctfilter,nil,turnp)
			if sg1:GetCount()>0 and ct1>0 and Duel.SelectYesNo(turnp,aux.Stringid(101108031,1)) then
				local ft1=Duel.GetLocationCount(turnp,LOCATION_SZONE)
				Duel.Hint(HINT_SELECTMSG,turnp,HINTMSG_SET)
				setg1=sg1:SelectSubGroup(turnp,c101108031.fselect,false,1,math.min(ct1,ft1+1),ft1)
			end
			local setg2=Group.CreateGroup()
			local sg2=Duel.GetMatchingGroup(Card.IsSSetable,1-turnp,LOCATION_HAND,0,nil)
			local ct2=og:FilterCount(c101108031.ctfilter,nil,1-turnp)
			if sg2:GetCount()>0 and ct2>0 and Duel.SelectYesNo(1-turnp,aux.Stringid(101108031,1)) then
				local ft2=Duel.GetLocationCount(1-turnp,LOCATION_SZONE)
				Duel.Hint(HINT_SELECTMSG,1-turnp,HINTMSG_SET)
				setg2=sg2:SelectSubGroup(1-turnp,c101108031.fselect,false,1,math.min(ct2,ft2+1),ft2)
			end
			if sg1:GetCount()>0 or sg2:GetCount()>0 then Duel.BreakEffect() end
			if sg1:GetCount()>0 then Duel.SSet(turnp,sg1,turnp,false) end
			if sg2:GetCount()>0 then Duel.SSet(1-turnp,sg2,1-turnp,false) end
		end
	end
end
