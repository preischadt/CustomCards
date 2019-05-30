--Dusker
function c420000056.initial_effect(c)
	--first ss
	c:EnableReviveLimit()
	--materials
	aux.AddFusionProcCodeFun(c, 28297833, c420000056.ffilter, 1, true, true)
	--limit
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	-- e1:SetValue(c420000056.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(1)
	e2:SetCondition(c420000056.sprcon)
	e2:SetOperation(c420000056.sprop)
	e2:SetCountLimit(1, 420000056)
	c:RegisterEffect(e2)

	--banish
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(420000056, 0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET + EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c420000056.cost)
	e1:SetTarget(c420000056.target)
	e1:SetOperation(c420000056.operation)
	c:RegisterEffect(e1)
end
function c420000056.ffilter(c)
	return (c:IsType(TYPE_XYZ) or c:IsCode(93568288)) and (c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_DARK))
end

function c420000056.spfilter1(c, tp)
	return c:IsCode(28297833) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(nil, true) and
		Duel.IsExistingMatchingCard(c420000056.spfilter2, tp, LOCATION_MZONE + LOCATION_SZONE, 0, 1, c)
end
function c420000056.spfilter2(c)
	return c420000056.ffilter(c) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(nil, true)
end
function c420000056.sprcon(e, c)
	if c == nil then
		return true
	end
	local tp = c:GetControler()
	return Duel.GetLocationCount(tp, LOCATION_MZONE) > -2 and
		Duel.IsExistingMatchingCard(c420000056.spfilter1, tp, LOCATION_MZONE + LOCATION_SZONE, 0, 1, nil, tp)
end
function c420000056.sprop(e, tp, eg, ep, ev, re, r, rp, c)
	Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(48156348, 2))
	local g1 = Duel.SelectMatchingCard(tp, c420000056.spfilter1, tp, LOCATION_MZONE + LOCATION_SZONE, 0, 1, 1, nil, tp)
	Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(48156348, 3))
	local g2 =
		Duel.SelectMatchingCard(tp, c420000056.spfilter2, tp, LOCATION_MZONE + LOCATION_SZONE, 0, 1, 1, g1:GetFirst())
	g1:Merge(g2)
	local tc = g1:GetFirst()
	while tc do
		--if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc = g1:GetNext()
	end
	Duel.Remove(g1, POS_FACEUP, REASON_COST)
end

function c420000056.costfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x03) and c:IsType(TYPE_MONSTER)
end
function c420000056.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(c420000056.costfilter, tp, LOCATION_GRAVE, 0, 1, e:GetHandler())
	end
	local rt = Duel.GetTargetCount(Card.IsAbleToRemove, tp, 0, LOCATION_ONFIELD, nil)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
	local cg = Duel.SelectMatchingCard(tp, c420000056.costfilter, tp, LOCATION_GRAVE, 0, 1, rt, nil)
	Duel.Remove(cg, POS_FACEUP, REASON_COST)
	e:SetLabel(cg:GetCount())
end
function c420000056.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsAbleToRemove()
	end
	if chk == 0 then
		return Duel.IsExistingTarget(Card.IsAbleToRemove, tp, 0, LOCATION_ONFIELD, 1, nil)
	end
	local ct = e:GetLabel()
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
	local eg = Duel.SelectTarget(tp, Card.IsAbleToRemove, tp, 0, LOCATION_ONFIELD, ct, ct, nil)
	Duel.SetOperationInfo(0, CATEGORY_REMOVE, eg, ct, 0, 0)
end
function c420000056.operation(e, tp, eg, ep, ev, re, r, rp, chk)
	local tg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
	local rg = tg:Filter(Card.IsRelateToEffect, nil, e)
	if rg:GetCount() > 0 then
		Duel.Remove(rg, POS_FACEUP, REASON_EFFECT)
	end
end
