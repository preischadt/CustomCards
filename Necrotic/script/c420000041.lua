--Lotus
function c420000041.initial_effect(c)
	--first ss
	c:EnableReviveLimit()
	--materials
	aux.AddFusionProcCodeFun(c,28297833,c420000041.ffilter,1,true,true)
	--limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c420000041.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(1)
	e2:SetCondition(c420000041.sprcon)
	e2:SetOperation(c420000041.sprop)
	e2:SetCountLimit(1, 420000041+100)
	c:RegisterEffect(e2)
	
	-- --pierce
	-- local e4=Effect.CreateEffect(c)
	-- e4:SetType(EFFECT_TYPE_SINGLE)
	-- e4:SetCode(EFFECT_PIERCE)
	-- c:RegisterEffect(e4)
	-- local e5=Effect.CreateEffect(c)
	-- e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	-- e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	-- e5:SetCondition(c420000041.damcon)
	-- e5:SetOperation(c420000041.damop)
	-- c:RegisterEffect(e5)
	
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetDescription(aux.Stringid(420000041,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1, 420000041)
	e1:SetTarget(c420000041.target)
	e1:SetOperation(c420000041.operation)
	c:RegisterEffect(e1)
end
function c420000041.ffilter(c)
	return c:IsType(TYPE_SYNCHRO) and (c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_DARK))
end

function c420000041.spfilter1(c,tp)
	return c:IsCode(28297833) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(nil,true)
		and Duel.IsExistingMatchingCard(c420000041.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c420000041.spfilter2(c)
	return c:IsType(TYPE_SYNCHRO) and (c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_DARK)) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(nil,true)
end
function c420000041.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c420000041.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c420000041.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48156348,2))
	local g1=Duel.SelectMatchingCard(tp,c420000041.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48156348,3))
	local g2=Duel.SelectMatchingCard(tp,c420000041.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		--if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end

function c420000041.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsDefensePos()
end
function c420000041.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end

function c420000041.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then return e:GetHandler():IsAbleToRemove() and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c420000041.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Group.FromCards(c, tc)
	g:KeepAlive()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and c:IsControler(tp) and tc:IsControler(tp) and Duel.Remove(g,nil,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetLabelObject(g)
		e1:SetCountLimit(1)
		e1:SetOperation(c420000041.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c420000041.retop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	local g=e:GetLabelObject()
	local tc = g:GetFirst()
	while tc do
		if tc:IsForbidden() then
			Duel.SendtoGrave(tc,REASON_RULE)
		else
			Duel.ReturnToField(tc)
		end
		tc = g:GetNext()
	end
end














