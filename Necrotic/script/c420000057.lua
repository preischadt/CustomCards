--Necroform
function c420000057.initial_effect(c)
	--first ss
	c:EnableReviveLimit()
	--materials
	aux.AddFusionProcCodeFun(c,28297833,c420000057.ffilter,1,true,true)
	--limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c420000057.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1, 420000057)
	e2:SetValue(1)
	e2:SetCondition(c420000057.sprcon)
	e2:SetOperation(c420000057.sprop)
	c:RegisterEffect(e2)
	
	--change code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(28297833)
	c:RegisterEffect(e1)
	
	--banish summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(420000057,0))
	e1:SetCode(EVENT_REMOVE)
	e1:SetTarget(c420000057.target)
	e1:SetOperation(c420000057.operation)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, 420000057+100)
	c:RegisterEffect(e1)
end
function c420000057.ffilter(c)
	return c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_DARK)
end
function c420000057.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end

function c420000057.spfilter1(c,tp)
	return c:IsCode(28297833) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(nil,true)
		and Duel.IsExistingMatchingCard(c420000057.spfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c)
end
function c420000057.spfilter2(c)
	return (c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_DARK)) and c:IsCanBeFusionMaterial() and c:IsAbleToRemoveAsCost()
end
function c420000057.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c420000057.spfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp)
end
function c420000057.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48156348,2))
	local g1=Duel.SelectMatchingCard(tp,c420000057.spfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48156348,3))
	local g2=Duel.SelectMatchingCard(tp,c420000057.spfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		--if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end

function c420000057.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c420000057.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end







































